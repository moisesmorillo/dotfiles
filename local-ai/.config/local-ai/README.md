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

`omlx/models.json` is the source of truth for the model repositories and their
directories below `~/.local/share/local-ai/omlx-models/`. It contains no model
weights, API keys, cache or mutable runtime state.

```bash
local-ai-models list
local-ai-models download core
local-ai-models download gemma26
local-ai-models dry-run qwen35
```

The command uses `uvx hf download --local-dir`, so it resumes safely and puts
each model directly in an oMLX-discoverable subdirectory. `core` contains the
Qwen general model plus the embedding model; experimental models are opt-in.

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
