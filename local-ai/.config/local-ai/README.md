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

## Pi against oMLX

After stowing `local-ai`, use `pi-local` rather than bare `pi` for the local
provider. It points Pi at the loopback-only oMLX OpenAI endpoint and resolves
the current oMLX API key into the process environment at request time; no API
key is stored in Pi's config or this repository. Pi's mutable state and
sessions live under `~/.local/state/local-ai/pi/`, not alongside these dotfiles.

Available models:

- `local-omlx/local-general:chat-fast`
- `local-omlx/local-general:coding-robust`

Pi's default compaction reserves 16K tokens, which is inappropriate for this
32K local profile. The bundled settings reserve 4K (enough for the 2,048-token
coding response) and retain the most recent 8K during compaction. Use
`/compact` before a large change when you want to control the summary boundary.
