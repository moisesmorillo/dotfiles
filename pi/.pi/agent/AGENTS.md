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
orchestration. Subagents default to `openai/gpt-6-luna` at medium thinking through the `subagents` settings;
the `reviewer` and `oracle` roles are raised to high there. When a skill asks you to pick a model for a subagent:

- Implementers working from a plan, and scoped re-reviews of small fix diffs: `openai/gpt-6-luna:medium`.
- Task reviewers and implementers working from prose without a plan: `openai/gpt-6-luna:high`.
- Architecture or design questions, the final whole-branch review, and fix-loop escalation after round 3:
  `openai/gpt-6.1-sol:medium`.
- Never leave the model unset so that a child silently inherits the parent model.

## Tools

- Use the `ask_user_question` tool when a real decision is open instead of guessing.
- Long shell work (test suites, builds, servers) goes through `bg_run`; a `failed` status means the
  command exited non-zero, so read `bg_logs` before retrying.
- A command that is expected to exit non-zero (negative control, "must fail" check) must not be the
  task's last command. Wrap it so the task exits 0 and records the observed code, for example
  `cmd; echo "observed exit=$?"`, then assert on the output. Only real failures may show as `failed`.
- Projects that contain a `backlog/` directory track work with Backlog.md: run
  `backlog instructions overview` once per session and keep task status current.

## Subagent execution

The worker owns the whole task: failing test, implementation, formatting, the project check command,
and the commit when the plan says to commit. The parent does not approve each step and does not
re-run the worker's tests between steps. The parent reviews once per task with one reviewer subagent,
then once per branch before the pull request. Escalate to the owner only a real blocker, a scope change,
or a decision the plan does not settle. A worker that stops on a decision gets one answer and the
authority to finish the task.

Do not write a workflow controller or a handoff parser inside a product task. Use the native
`subagent` async run plus one reviewer. If a scripted workflow fails, fall back to the native run and
add a deferred Backlog task for the controller.

## Background tasks

This section applies to the parent session. A worker subagent has no `bg_run`. It runs the project check with its own shell and waits for the result.

End every `bg_run` command with a summary line: pass and fail counts and the exit code. Read `bg_logs`
only after a terminal notification and only when the summary is not enough. The `agent-budget` extension caps the read at
4 KiB. The full output stays in `.pi/tasks/`.

## Sessions

One session per Backlog task or pull request. After the owner merges a pull request, stop and report. The
owner starts a new session. State lives in Backlog.md, the plan file, and the memory session summary,
not in the conversation.

## Decision gates

Batch open decisions into one `ask_user_question` per plan. Open one Plannotator review per plan and
one per branch, not one per task.

## Memory

Save memory at three moments: a decision the owner made, a bug root cause, and the session summary.
Do not save progress steps, validation results, or supervisor replies. The `agent-budget` extension
blocks a repeat of the same topic inside 30 minutes and more than six saves per hour.

## Prose checks

The `agent-budget` extension removes `ste_lint` from the tools declared to the model. agent-ste still
blocks a hard fault on a write or a commit message and reports faults on a reply. Do not look for a
lint tool before a reply.
