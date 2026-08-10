#!/usr/bin/env python3
"""Loopback-only deterministic OpenAI-compatible server for harness self-tests."""

from __future__ import annotations

import argparse
import json
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from typing import Any


def _assistant_response(content: str, tool_calls: list[dict[str, Any]] | None = None) -> dict[str, Any]:
    message: dict[str, Any] = {"role": "assistant", "content": content}
    finish_reason = "stop"
    if tool_calls:
        message["tool_calls"] = tool_calls
        finish_reason = "tool_calls"
    return {
        "id": "chatcmpl-local-ai-self-test",
        "object": "chat.completion",
        "model": "mock-local-general",
        "choices": [{"index": 0, "message": message, "finish_reason": finish_reason}],
        "usage": {"prompt_tokens": 32, "completion_tokens": 16, "total_tokens": 48},
    }


def _tool_call(call_id: str, name: str, arguments: dict[str, Any]) -> dict[str, Any]:
    return {
        "id": call_id,
        "type": "function",
        "function": {"name": name, "arguments": json.dumps(arguments, separators=(",", ":"))},
    }


class MockHandler(BaseHTTPRequestHandler):
    server_version = "LocalAIBenchmarkMock/1.0"

    def log_message(self, _format: str, *_args: Any) -> None:
        return

    def _write_json(self, status: int, payload: dict[str, Any]) -> None:
        body = json.dumps(payload).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self) -> None:  # noqa: N802
        if self.path.rstrip("/") == "/v1/models":
            self._write_json(
                200,
                {"object": "list", "data": [{"id": "mock-local-general", "object": "model"}]},
            )
            return
        self._write_json(404, {"error": {"message": "not found"}})

    def do_POST(self) -> None:  # noqa: N802
        if self.path.rstrip("/") != "/v1/chat/completions":
            self._write_json(404, {"error": {"message": "not found"}})
            return

        length = int(self.headers.get("Content-Length", "0"))
        request = json.loads(self.rfile.read(length) or b"{}")
        messages = request.get("messages", [])
        tool_results = [message for message in messages if message.get("role") == "tool"]

        if request.get("tools"):
            response = self._tool_response(len(tool_results))
        else:
            response = _assistant_response(
                "Root cause: OOMKilled. Raise the request to 384Mi and the limit to 512Mi. "
                "Verify the rollout and keep a rollback command."
            )

        if request.get("stream"):
            self._write_stream(response)
        else:
            self._write_json(200, response)

    def _tool_response(self, completed: int) -> dict[str, Any]:
        if completed == 0:
            call = _tool_call(
                "call-events",
                "get_pod_events",
                {"namespace": "payments", "pod": "payments-api-7b8d9"},
            )
            return _assistant_response("", [call])
        if completed == 1:
            call = _tool_call(
                "call-manifest",
                "get_deployment_manifest",
                {"namespace": "payments", "name": "payments-api"},
            )
            return _assistant_response("", [call])
        if completed == 2:
            call = _tool_call(
                "call-validate",
                "validate_patch",
                {
                    "namespace": "payments",
                    "name": "payments-api",
                    "patch": {"resources": {"requests": {"memory": "384Mi"}, "limits": {"memory": "512Mi"}}},
                },
            )
            return _assistant_response("", [call])
        return _assistant_response("The dry-run validator accepted the candidate patch; nothing was applied.")

    def _write_stream(self, response: dict[str, Any]) -> None:
        message = response["choices"][0]["message"]
        content = message.get("content") or ""
        self.send_response(200)
        self.send_header("Content-Type", "text/event-stream")
        self.send_header("Cache-Control", "no-cache")
        self.end_headers()
        for fragment in (content[: len(content) // 2], content[len(content) // 2 :]):
            if not fragment:
                continue
            chunk = {
                "id": response["id"],
                "object": "chat.completion.chunk",
                "choices": [{"index": 0, "delta": {"content": fragment}, "finish_reason": None}],
            }
            self.wfile.write(f"data: {json.dumps(chunk)}\n\n".encode("utf-8"))
            self.wfile.flush()
        usage = {"choices": [], "usage": response["usage"]}
        self.wfile.write(f"data: {json.dumps(usage)}\n\n".encode("utf-8"))
        self.wfile.write(b"data: [DONE]\n\n")
        self.wfile.flush()


def create_server(host: str = "127.0.0.1", port: int = 0) -> ThreadingHTTPServer:
    return ThreadingHTTPServer((host, port), MockHandler)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--host", default="127.0.0.1", choices=["127.0.0.1", "localhost"])
    parser.add_argument("--port", type=int, default=18080)
    args = parser.parse_args()
    server = create_server(args.host, args.port)
    print(f"mock server listening on http://{args.host}:{server.server_port}/v1", flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
