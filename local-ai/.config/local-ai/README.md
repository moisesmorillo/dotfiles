# Local AI configuration

This GNU Stow package contains reproducible local-AI client configuration.

It deliberately excludes:

- model weights and runtime caches;
- API keys and cloud credentials;
- benchmark fixtures and results;
- application databases;
- generated long-context corpora.

Runtime state is written below `~/.local/state/local-ai/`. Secrets are resolved at runtime and are never stored in this repository.

## Pi against oMLX

After stowing `local-ai`, use `pi-local` rather than bare `pi` for the local
provider. It points Pi at the loopback-only oMLX OpenAI endpoint and resolves
the current oMLX API key into the process environment at request time; no API
key is stored in Pi's config or this repository. Pi's mutable state and
sessions live under `~/.local/state/local-ai/pi/`, not alongside these dotfiles.

Available profiles:

- `local-omlx/local-general:general-128k`
- `local-omlx/local-general:coding-128k`
- `local-omlx/local-general:coding-256k`
- `local-omlx/gemma-4-26B-A4B-it-qat-4bit:experimental-128k`

Pi's bundled settings reserve 4K tokens for a 2,048-token response and retain
the most recent 8K during compaction. Use
`/compact` before a large change when you want to control the summary boundary.
