#!/usr/bin/env python3
"""One-shot, read-only concurrency probe for a loopback oMLX endpoint."""
from __future__ import annotations

import json
import os
import sys
import time
import urllib.request
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path


BASE_URL = os.environ.get("OMLX_PROBE_BASE_URL", "http://127.0.0.1:8000/v1").rstrip("/") + "/chat/completions"
MODEL = os.environ.get("OMLX_PROBE_MODEL", "local-general:coding-robust")


def invoke(corpus: str, api_key: str, label: str, marker: str) -> dict[str, object]:
    prompt = (
        f"Independent agent {label}; do not share context with other agents.\n"
        "Read the corpus below and reply exactly with its controlled retrieval marker.\n\n"
        "--- BEGIN CORPUS ---\n" + corpus + "\n--- END CORPUS ---"
    )
    body = json.dumps(
        {
            "model": MODEL,
            "messages": [{"role": "user", "content": prompt}],
            "max_tokens": 64,
            "temperature": 0,
            "chat_template_kwargs": {"enable_thinking": False},
        }
    ).encode()
    request = urllib.request.Request(
        BASE_URL,
        data=body,
        method="POST",
        headers={"Content-Type": "application/json", "Authorization": f"Bearer {api_key}"},
    )
    started = time.monotonic()
    with urllib.request.urlopen(request, timeout=900) as response:
        result = json.loads(response.read())
    elapsed = time.monotonic() - started
    message = result["choices"][0]["message"].get("content", "")
    usage = result.get("usage", {})
    return {
        "label": label,
        "seconds": round(elapsed, 2),
        "prompt_tokens": usage.get("prompt_tokens"),
        "completion_tokens": usage.get("completion_tokens"),
        "marker_found": marker in message,
        "finish_reason": result["choices"][0].get("finish_reason"),
    }


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: concurrency_probe.py CORPUS MARKER", file=sys.stderr)
        return 2
    api_key = os.environ.get("LOCAL_AI_API_KEY")
    if not api_key:
        print("LOCAL_AI_API_KEY must be set", file=sys.stderr)
        return 2
    corpus = Path(sys.argv[1]).read_text(encoding="utf-8")
    marker = sys.argv[2]
    baseline = invoke(corpus, api_key, "baseline", marker)
    parallel_started = time.monotonic()
    with ThreadPoolExecutor(max_workers=2) as pool:
        parallel = list(pool.map(lambda label: invoke(corpus, api_key, label, marker), ["parallel-a", "parallel-b"]))
    print(
        json.dumps(
            {
                "model": MODEL,
                "baseline": baseline,
                "parallel": parallel,
                "parallel_wall_seconds": round(time.monotonic() - parallel_started, 2),
            },
            indent=2,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
