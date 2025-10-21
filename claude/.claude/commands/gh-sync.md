---
description: Sync local changes to GitHub with automated PR creation
---

## Git Flow & Branching

* If currently on main/master, create a new branch following Git Flow naming conventions:
  * `feature/*` for new features (e.g., `feature/user-authentication`)
  * `bugfix/*` for bug fixes (e.g., `bugfix/email-validation-error`)
  * `hotfix/*` for production hotfixes (e.g., `hotfix/critical-login-issue`)
  * `refactor/*` for code improvements (e.g., `refactor/optimize-database-queries`)

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
