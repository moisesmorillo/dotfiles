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

Two tiers exist. The session model runs brainstorming, specs, plans, orchestration, the final
whole-branch review, and architecture questions. The subagent model from `subagents.defaultModel`
in `settings.json` runs implementers and task reviewers at high thinking. Scoped re-reviews of
small fix diffs run on the subagent model at medium thinking. The `code-review` and `design-review`
profiles run on the subagent model. The `branch-review` profile runs on the session model. Use it
only for the final whole-branch review. Never leave a child model unset so that a child silently
inherits the parent model.

The session model is the most capable model configured. Escalate one tier when the subagent model
is not capable enough. The signals are two incomplete deliveries of the same brief without a named
blocker, or the same fix finding open after round 3. Then relaunch only the remaining scope on the
session model with a fresh context. Do not ask the owner. Record the escalation and its signal in the
task notes. A project rule about model approval does not apply to this escalation.

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

A completion notice does not survive an owner gate. Before an `ask_user_question` or a Plannotator
gate, and again right after the owner answers, call `bg_status` once for each task started before
the gate. Do not end a turn to wait for the notice of a task that is older than an owner gate.

A guard block on one command is a command error, not a tool outage. Fix the command and continue.
Escalate to the owner only after two different valid commands receive the same block.

## Sessions

One session per Backlog task or pull request. After the owner merges a pull request, stop and report. The
owner starts a new session. State lives in Backlog.md, the plan file, and the memory session summary,
not in the conversation.

## Decision gates

Batch open decisions into one `ask_user_question` per plan. Open one Plannotator review per plan and
one per branch, not one per task.

Before an owner question, search the project specification for the answer. A question the
specification answers is not an owner decision. Cite the line in the plan and continue. When the
specification is silent and a default keeps every contract and invariant, choose the default. Record
it in the plan as a decision for the plan gate. Ask only when each option changes a contract, a cost,
or a deliverable.

Run every feasibility probe during planning, before the plan review. A probe is a read-only test of
a runtime or platform capability, such as a SQLite feature or an API limit. Put its result and the
decision it needs in the plan and in the plan gate. An approved plan cannot contain an owner gate.
A plan step that says "stop and ask the owner" is a planning defect. Resolve it before the review.

Ask the owner once per scope. After the owner approves a scope, do not ask again before the pull
request. The only exceptions are a project check that cannot pass and a change to the spec. Never
offer "stop and preserve the work" as an option. The owner stops the work by saying so.

A review finding that needs evidence the repository cannot produce is not a blocker. Record it as
intentionally deferred, cite the owner decision, and add a Backlog task with a trigger. Then continue
to the pull request. A reviewer gives a verdict on the evidence it has. It does not ask for
experiments, designs, or more investigation runs. A plan or brief written in the session cannot
forbid this deferral.

## Memory

Save memory at three moments: a decision the owner made, a bug root cause, and the session summary.
Do not save progress steps, validation results, or supervisor replies. The `agent-budget` extension
blocks a repeat of the same topic inside 30 minutes and more than six saves per hour.

## Prose checks

The `agent-budget` extension removes `ste_lint` from the tools declared to the model. agent-ste still
blocks a hard fault on a write or a commit message and reports faults on a reply. Do not look for a
lint tool before a reply.
