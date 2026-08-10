# Reproducible local AI benchmark

The harness compares OpenAI-compatible runtimes under fixed prompts, sampling parameters, tool schemas, and scoring
rules. Every run stores its full manifest and raw response outside Git.

## Lifecycle

1. `validate` checks configuration, prompts, scenarios, and tool schemas without contacting a model.
2. `self-test` starts a loopback-only mock API and exercises streaming, metrics, scoring, and tool-call orchestration.
3. `run ID` executes a scenario against the configured endpoint.
4. `summarize` aggregates the most recent run directory as JSON.

The disabled `long-context-needle` scenario becomes runnable only after
generating its ignored corpus. Use `generate_long_context.py` with a unique
`--needle`; it reports the model-specific input-token count through oMLX's
loopback token-count endpoint. Keep the generated corpus and its needle out of
Git, then enable the scenario deliberately for the target context ladder.
For an explicitly prepared one-off, `run --allow-disabled long-context-needle`
keeps the scenario disabled in source control while recording the run normally.

## Result layout

```text
~/.local/state/local-ai/benchmarks/
└── YYYYMMDDTHHMMSSZ-model-scenario/
    ├── manifest.json
    ├── host-before.json
    ├── repetition-01.json
    ├── repetition-02.json
    ├── repetition-03.json
    ├── host-after.json
    └── summary.json
```

`generated_tokens_per_second` is computed only when the API returns token usage. Prefill throughput remains `null`
unless a backend exposes reliable timing metadata; the harness never invents it from wall-clock latency.

## Safety model

- endpoints must resolve to loopback unless explicitly overridden;
- mock tools return static fixture data and have no shell, filesystem, Kubernetes, or cloud access;
- prompts and results are treated as untrusted data;
- API keys are never serialized into manifests;
- the research and production-action scenarios require manual or later sandboxed evaluators.
