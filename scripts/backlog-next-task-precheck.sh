#!/usr/bin/env bash
# Exit 0 when the next Backlog.md subtask under a gate task can start in a repository.
# Used by agent-next-task.sh.
# Exit codes: 3 no ready subtask, 4 open pull request, 5 subtask in progress,
# 6 live pi session in the repository, 7 main checkout not updatable, 2 bad arguments.
set -euo pipefail

REPO="${1:?usage: backlog-next-task-precheck.sh <repo-path> <gate-task-id> [branch-prefix]}"
GATE="${2:?usage: backlog-next-task-precheck.sh <repo-path> <gate-task-id> [branch-prefix]}"
PREFIX="${3:-feature/}"

cd "$REPO"

# Backlog.md state lives in git. Update the main checkout first, or a merged
# subtask still looks ready and the agent starts it a second time.
branch="$(git rev-parse --abbrev-ref HEAD)"
if [ "$branch" != "main" ] || [ -n "$(git status --porcelain)" ]; then
	echo "precheck: $REPO is not a clean main checkout ($branch)"
	exit 7
fi
if ! git fetch -q origin main || ! git merge --ff-only -q origin/main; then
	echo "precheck: cannot fast-forward main in $REPO"
	exit 7
fi

in_progress="$(backlog task list --plain -s "In Progress" -p "$GATE" 2>/dev/null | grep -cE '^  [A-Z]+-[0-9.]+ - ' || true)"
if [ "$in_progress" -gt 0 ]; then
	echo "precheck: $in_progress subtask(s) of $GATE in progress"
	exit 5
fi

next="$(backlog task list --plain --ready -p "$GATE" 2>/dev/null | awk '/^  [A-Z]+-[0-9.]+ - /{print $1; exit}')"
if [ -z "$next" ]; then
	echo "precheck: no ready subtask under $GATE"
	exit 3
fi

open_prs="$(gh pr list --state open --json headRefName --jq '.[].headRefName' 2>/dev/null | grep -c "^$PREFIX" || true)"
if [ "$open_prs" -gt 0 ]; then
	echo "precheck: $open_prs open pull request(s) from $PREFIX*"
	exit 4
fi

if command -v "${HC_BIN:-hc}" >/dev/null 2>&1; then
	# Each entry of `hc ls --json` has the agent that reports in it and its folder.
	live="$("${HC_BIN:-hc}" ls --json 2>/dev/null \
		| jq -r --arg repo "$REPO" --arg self "${HC_TERMINAL_ID:-}" '
			[.terminals[]? | select(.agent == "pi" and .address != $self and ((.cwd // "") | startswith($repo)))]
			| length' 2>/dev/null || echo 0)"
	if [ "${live:-0}" -gt 0 ]; then
		echo "precheck: $live live pi agent(s) in herdr-core"
		exit 6
	fi
fi

echo "precheck: $next is ready"
exit 0
