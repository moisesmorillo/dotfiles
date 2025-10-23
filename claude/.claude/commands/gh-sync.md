---
description: Sync local changes to GitHub with automated PR creation
---

## Git Flow & Branching

* If currently on main/master, create a new branch following Git Flow naming conventions:
  * `feature/*` for new features (e.g., `feature/user-authentication`)
  * `bugfix/*` for bug fixes (e.g., `bugfix/email-validation-error`)
  * `hotfix/*` for production hotfixes (e.g., `hotfix/critical-login-issue`)
  * `refactor/*` for code improvements (e.g., `refactor/optimize-database-queries`)
* If currently on any other branch, proceed with the rest of the workflow without creating a new branch

## Linting, Formatting & Testing

* Detect the project type by checking for configuration files and run the appropriate tools:

### Node.js Projects

* Detect the package manager by checking for lock files (in priority order):
  * `bun.lockb` → use `bun`
  * `pnpm-lock.yaml` → use `pnpm`
  * `yarn.lock` → use `yarn`
  * `package-lock.json` → use `npm`
  * If no lock file exists, check for `.npmrc`, `.yarnrc`, or `pnpm-workspace.yaml` to determine the package manager
  * Default to `npm` if no indicators are found

* Run commands using the detected package manager (examples for npm; replace with yarn/pnpm/bun as appropriate):
  * Linting: `npm run lint` or `npm lint`
  * Formatting: `npm run format` or `npm format`
  * Testing: `npm test` or `npm run test`

### Python Projects

* Detect the virtual environment manager by checking for configuration files and lock files (in priority order):
  * `uv.lock` → use `uv` (modern package and virtual environment manager)
  * `poetry.lock` → use `poetry`
  * `Pipfile` → use `pipenv`
  * `venv/`, `.venv/`, `env/` → activate the existing virtual environment
  * If no package manager is detected, check for a `Makefile` to see if it contains environment setup commands

* Activate the virtual environment if it exists but is not already activated:
  * For `uv`: `uv sync` (automatically creates and activates the environment)
  * For `poetry`: `poetry shell` or use `poetry run` for individual commands
  * For `pipenv`: `pipenv shell` or use `pipenv run` for individual commands
  * For venv-based projects (macOS/Linux): `source venv/bin/activate` (or `.venv/bin/activate`)
  * For venv-based projects (Windows): `venv\Scripts\activate` or `venv\Scripts\activate.bat`
  * If no virtual environment exists, warn the user but proceed (the project may use system Python or a container)

* Look for: `pyproject.toml`, `setup.py`, `Makefile`, `.flake8`, `setup.cfg`, `tox.ini`, `uv.lock`
* Run commands (if configured):
  * Using `uv`: `uv run flake8`, `uv run black`, `uv run pytest` (uv handles virtual environment automatically)
  * Using `poetry`: `poetry run flake8`, `poetry run black`, `poetry run pytest`
  * Using `pipenv`: `pipenv run flake8`, `pipenv run black`, `pipenv run pytest`
  * Using venv or system Python: `flake8 .`, `black .`, `pytest` (ensure virtual environment is activated first)
  * Or run: `make lint`, `make format`, `make test` if a `Makefile` exists
  * Specific tools:
    * Linting: `flake8 .` or `pylint` (check `pyproject.toml` for configuration)
    * Formatting: `black .` or `autopep8` (check `pyproject.toml` for tool configuration)
    * Testing: `pytest` or `python -m unittest` (check `pyproject.toml` for pytest config)

### Go Projects

* Look for: `go.mod`, `go.sum`, `Makefile`, `.golangci.yml`, `golangci.toml`
* Run commands (if configured):
  * Linting: `golangci-lint run ./...` (check `.golangci.yml` for configuration)
  * Formatting: `go fmt ./...` (built-in, usually required)
  * Testing: `go test ./...` (built-in)
  * Or run: `make lint`, `make fmt`, `make test` if a `Makefile` exists

* Do not proceed until all checks pass
* If no configuration files are found, skip linting and formatting, but still attempt to run tests

## Staging & Committing

* Stage all modified files using `git add .` (do not ignore or exclude files unless explicitly specified by the user)
* Write a clear, concise commit message following the Conventional Commits format:
  * `feat: added user CRUD endpoints`
  * `fix: prevent email from sending on registration error`
  * `refactor: simplify authentication service`
  * `docs: update API endpoint documentation`
  * `test: add unit tests for payment processing`
* Keep commit messages and branch names in English unless explicitly specified otherwise by the user

## Pushing & Creating PR

* Push changes to the remote origin repository using `git push origin [branch-name]`
* Use the GitHub CLI (`gh`) to create a Pull Request with a detailed description:
  * The PR description should include context, motivation, and any details omitted from the commit message
  * Example: `gh pr create --title "Add user authentication" --body "This PR implements JWT-based user authentication with refresh tokens. Includes login, logout, and token refresh endpoints."`
* Display the PR URL once created
