#!/usr/bin/env python3
"""Compare initial and shared-prefix reuse latency through oMLX."""
from __future__ import annotations

import json
import os
import sys
import time
import urllib.request
from pathlib import Path


BASE_URL = os.environ.get("OMLX_PROBE_BASE_URL", "http://127.0.0.1:8000/v1").rstrip("/") + "/chat/completions"
MODEL = os.environ.get("OMLX_PROBE_MODEL", "local-general:coding-256k")


def invoke(corpus: str, marker: str, api_key: str) -> dict[str, object]:
    payload = json.dumps(
        {
            "model": MODEL,
            "messages": [{"role": "user", "content": corpus + "\n\nReply exactly with the controlled retrieval marker."}],
            "max_tokens": 64,
            "temperature": 0,
            "chat_template_kwargs": {"enable_thinking": False},
        }
    ).encode()
    request = urllib.request.Request(
        BASE_URL,
        data=payload,
        method="POST",
        headers={"Content-Type": "application/json", "Authorization": f"Bearer {api_key}"},
    )
    started = time.monotonic()
    with urllib.request.urlopen(request, timeout=1800) as response:
        result = json.loads(response.read())
    message = result.get("choices", [{}])[0].get("message", {}).get("content", "")
    usage = result.get("usage", {})
    return {
        "seconds": round(time.monotonic() - started, 2),
        "prompt_tokens": usage.get("prompt_tokens"),
        "completion_tokens": usage.get("completion_tokens"),
        "marker_found": marker in message,
        "finish_reason": result.get("choices", [{}])[0].get("finish_reason"),
        "error": result.get("error"),
    }


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: prefix_reuse_probe.py CORPUS MARKER", file=sys.stderr)
        return 2
    api_key = os.environ.get("LOCAL_AI_API_KEY")
    if not api_key:
        print("LOCAL_AI_API_KEY must be set", file=sys.stderr)
        return 2
    corpus = Path(sys.argv[1]).read_text(encoding="utf-8")
    marker = sys.argv[2]
    first = invoke(corpus, marker, api_key)
    second = invoke(corpus, marker, api_key)
    print(json.dumps({"model": MODEL, "first": first, "second_shared_prefix": second}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
