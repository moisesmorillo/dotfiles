#!/usr/bin/env python3
"""Run two independent, differently sized oMLX requests concurrently."""
from __future__ import annotations

import json
import os
import sys
import time
import urllib.request
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path


BASE_URL = os.environ.get("OMLX_PROBE_BASE_URL", "http://127.0.0.1:8000/v1").rstrip("/") + "/chat/completions"
MODEL = os.environ.get("OMLX_PROBE_MODEL", "local-general:coding-256k")


def invoke(corpus_path: str, marker: str, label: str, api_key: str) -> dict[str, object]:
    corpus = Path(corpus_path).read_text(encoding="utf-8")
    prompt = (
        f"Independent agent {label}; do not share context with other agents.\n"
        "Read the corpus below and reply exactly with its controlled retrieval marker.\n\n"
        "--- BEGIN CORPUS ---\n" + corpus + "\n--- END CORPUS ---"
    )
    payload = json.dumps(
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
        data=payload,
        method="POST",
        headers={"Content-Type": "application/json", "Authorization": f"Bearer {api_key}"},
    )
    started = time.monotonic()
    with urllib.request.urlopen(request, timeout=1800) as response:
        result = json.loads(response.read())
    elapsed = round(time.monotonic() - started, 2)
    if "choices" not in result:
        return {
            "label": label,
            "seconds": elapsed,
            "prompt_tokens": None,
            "completion_tokens": None,
            "marker_found": False,
            "finish_reason": None,
            "error": result,
        }
    message = result["choices"][0]["message"].get("content", "")
    usage = result.get("usage", {})
    return {
        "label": label,
        "seconds": elapsed,
        "prompt_tokens": usage.get("prompt_tokens"),
        "completion_tokens": usage.get("completion_tokens"),
        "marker_found": marker in message,
        "finish_reason": result["choices"][0].get("finish_reason"),
    }


def main() -> int:
    if len(sys.argv) != 5:
        print("usage: mixed_concurrency_probe.py LONG_CORPUS LONG_MARKER SHORT_CORPUS SHORT_MARKER", file=sys.stderr)
        return 2
    api_key = os.environ.get("LOCAL_AI_API_KEY")
    if not api_key:
        print("LOCAL_AI_API_KEY must be set", file=sys.stderr)
        return 2
    long_corpus, long_marker, short_corpus, short_marker = sys.argv[1:]
    started = time.monotonic()
    with ThreadPoolExecutor(max_workers=2) as pool:
        coordinator = pool.submit(invoke, long_corpus, long_marker, "coordinator-long", api_key)
        subagent = pool.submit(invoke, short_corpus, short_marker, "subagent-short", api_key)
        results = [coordinator.result(), subagent.result()]
    print(json.dumps({"model": MODEL, "results": results, "wall_seconds": round(time.monotonic() - started, 2)}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
