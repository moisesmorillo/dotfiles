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

## Models

The session default is `openai/gpt-6.1-sol` at medium thinking: it runs brainstorming, specs, plans and
orchestration. Subagents default to `openai/gpt-6-luna` at high thinking through the `subagents` settings.
When a skill asks you to pick a model for a subagent:

- Implementers, task reviewers and scoped re-reviews: `openai/gpt-6-luna:high`.
- Architecture or design questions, the final whole-branch review, and fix-loop escalation after round 3:
  `openai/gpt-6.1-sol:medium`.
- Never leave the model unset so that a child silently inherits the parent model.

## Tools

- Use the `ask_user_question` tool when a real decision is open instead of guessing.
- Long shell work (test suites, builds, servers) goes through `bg_run`; a `failed` status means the
  command exited non-zero, so read `bg_logs` before retrying.
- Projects that contain a `backlog/` directory track work with Backlog.md: run
  `backlog instructions overview` once per session and keep task status current.
