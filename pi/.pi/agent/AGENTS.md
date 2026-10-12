# Global Pi Instructions

These instructions apply in every working directory. Project `AGENTS.md` files add to them.

## Work in Git worktrees

Declared worktree preference for the `using-git-worktrees` skill: **always isolate code changes in a
worktree, without asking for consent.**

- Before editing files in a Git repository, follow the `using-git-worktrees` skill. Detect existing
  isolation first; if the current checkout is already a linked worktree, keep working there.
- Worktree directory: `~/.worktrees/<repo>/<branch>`, where `<repo>` is the basename of the main
  worktree. This matches the default root of the `/worktree` command, so both views agree.
- Branch names follow Git Flow: `feature/*`, `bugfix/*`, `hotfix/*`, `refactor/*`, `chore/*`.
- Read-only tasks (questions, reviews, explanations) do not need a worktree.

## Finish every branch

When the work is complete and the tests pass, follow the `finishing-a-development-branch` skill.
Default choice unless the user says otherwise: push the branch, open a pull request with `gh pr create`
(title and body in English, conventional commit style), then remove the worktree. Never merge locally
into `main` and never delete a branch that has unpushed commits.

## Tools

- Use the `ask_user_question` tool when a real decision is open instead of guessing.
- Long shell work (test suites, builds, servers) goes through `bg_run`; a `failed` status means the
  command exited non-zero, so read `bg_logs` before retrying.
- Projects that contain a `backlog/` directory track work with Backlog.md: run
  `backlog instructions overview` once per session and keep task status current.
