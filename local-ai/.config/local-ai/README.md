# Local AI configuration

This GNU Stow package contains only reproducible configuration, benchmark fixtures, and read-only diagnostics.

It deliberately excludes:

- model weights and runtime caches;
- API keys and cloud credentials;
- raw benchmark results;
- application databases;
- generated long-context corpora.

Runtime state is written below `~/.local/state/local-ai/`. Secrets are read from environment variables only.

## Commands

```bash
local-ai-doctor
local-ai-bench validate
local-ai-bench list
local-ai-bench self-test
local-ai-bench run sre-k8s-oomkill \
  --model local-general \
  --runtime ollama \
  --runtime-version 0.31.2 \
  --quantization mlx-4bit \
  --context-tokens 32768
local-ai-bench summarize
```

The benchmark refuses remote endpoints by default. Set `LOCAL_AI_ALLOW_REMOTE_ENDPOINT=1` deliberately when testing a
cloud provider.
