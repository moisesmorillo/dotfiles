---
description: Sync local changes to GitHub with automated PR creation
agent: build
model: openrouter/z-ai/glm-4.5-air:free
subtask: true
---

Sync my changes to GitHub following this workflow:

1. Check current branch. If on main/master, create a new branch using Git Flow conventions (feature/* for features, bugfix/* for fixes, hotfix/* for urgent fixes, refactor/* for improvements).

2. Check conversation history - if tests/linting already ran AND no files changed (verify with `git status --porcelain`), skip checks. Otherwise:
   - Check for mise/rtx (.mise.toml or .tool-versions) and use `mise exec` or `mise run` if available
   - Detect project type: Check for package.json (JS/TS), go.mod (Go), or pyproject.toml/setup.py (Python)
   - Discover commands by checking package.json scripts, Makefile targets, mise tasks, or common tool configs
   - For JS/TS: Detect package manager (bun.lockb→bun, pnpm-lock.yaml→pnpm, yarn.lock→yarn, package-lock.json→npm). Check if tools are available via mise first. Run lint/format/test scripts if they exist
   - For Go: Run `golangci-lint run` if .golangci.yml exists, `go fmt`, and `go test ./...`
   - For Python: Detect tool (uv.lock→uv, poetry.lock→poetry, Pipfile→pipenv), run flake8/black/pytest if configured
   - Don't proceed until all checks pass

3. Stage all changes with `git add .` and create a conventional commit message (feat:/fix:/refactor:/docs:/test:).

4. Push to origin and create a PR using `gh pr create` with a detailed description including context and motivation.

Keep branch names and messages in English.
