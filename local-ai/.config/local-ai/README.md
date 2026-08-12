# Local AI configuration

This GNU Stow package contains reproducible local-AI client configuration and
a declarative oMLX model catalogue.

It deliberately excludes:

- model weights and runtime caches;
- API keys and cloud credentials;
- benchmark fixtures and results;
- application databases;
- generated long-context corpora.

Runtime state is written below `~/.local/state/local-ai/`. Secrets are resolved at runtime and are never stored in this repository.

## Model catalogue and download

`omlx/models.json` is the source of truth for provider-specific model
repositories and directories below `~/.local/share/models/`. It contains no
model weights, API keys, cache or mutable runtime state. The layout is designed
for multiple runtimes: `models/omlx/` for MLX safetensors and `models/llama.cpp/`
for GGUF.

```bash
local-ai-models list                         # oMLX is the default provider
local-ai-models list --provider omlx
local-ai-models configure --provider omlx
local-ai-models download core --provider omlx
local-ai-models dry-run qwen35
local-ai-models list --provider llama.cpp
```

The command uses `uvx hf download --local-dir`, so it resumes safely and puts
each model directly in its provider subdirectory. `core` contains the Qwen
general model plus the embedding model; experimental models are opt-in. The
`llama.cpp` provider is ready for GGUF entries when a model is added to the
catalogue.

`configure --provider omlx` applies the Qwen alias (`local-general`) and its
operational context profiles, then points oMLX at `models/omlx/`. It makes
timestamped backups of the affected oMLX configuration files and never copies
API keys or model weights. Restart oMLX afterwards.

## Pi and OpenCode against oMLX

Use oMLX's supported integration to select a Pi model directly:

```bash
omlx launch pi
omlx launch pi --model local-general:coding-256k
```

The first command opens oMLX's model picker and writes Pi's own runtime
configuration under `~/.pi/agent/`; it is intentionally not managed by Stow.
OpenCode keeps explicit model definitions because it needs local context and
output limits for each selectable profile.

## Fresh-machine onboarding

```bash
brew tap jundot/omlx
brew install jundot/omlx/omlx
mise use -g uv@latest
stow -t "$HOME" local-ai opencode
brew services start jundot/omlx/omlx
local-ai-models configure --provider omlx
local-ai-models download core --provider omlx
brew services restart jundot/omlx/omlx
omlx launch pi
```

In OpenCode, run `opencode auth login` once, select `local-omlx`, and supply
the oMLX API key from `~/.omlx/settings.json`. Verify the running service with
`local-ai-models list` and `curl http://127.0.0.1:8000/v1/models` using that
same key.
