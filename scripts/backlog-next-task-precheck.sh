#!/usr/bin/env bash
# Exit 0 when the next Backlog.md subtask under a gate task can start in a repository.
# Used as the precheck of an Orca automation and by agent-next-task.sh.
# Exit codes: 3 no ready subtask, 4 open pull request, 5 subtask in progress,
# 6 live pi session in the repository, 2 bad arguments.
set -euo pipefail

REPO="${1:?usage: backlog-next-task-precheck.sh <repo-path> <gate-task-id> [branch-prefix]}"
GATE="${2:?usage: backlog-next-task-precheck.sh <repo-path> <gate-task-id> [branch-prefix]}"
PREFIX="${3:-feature/}"
ORCA_BIN="${ORCA_BIN:-orca}"
if ! command -v "$ORCA_BIN" >/dev/null 2>&1 && [ -x /Applications/Orca.app/Contents/Resources/bin/orca ]; then
	ORCA_BIN=/Applications/Orca.app/Contents/Resources/bin/orca
fi

cd "$REPO"

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

if [ -x "$ORCA_BIN" ] || command -v "$ORCA_BIN" >/dev/null 2>&1; then
	live="$("$ORCA_BIN" terminal list --json 2>/dev/null \
		| jq -r --arg repo "$REPO" --arg base "$(basename "$REPO")" '
			(.result.terminals // .terminals // [])
			| map(select(.agentIdentity == "pi" and ((.worktreePath // "") | (startswith($repo) or contains("/" + $base + "/")))))
			| length' 2>/dev/null || echo 0)"
	if [ "${live:-0}" -gt 0 ]; then
		echo "precheck: $live live pi session(s) in $REPO"
		exit 6
	fi
elif [ "${HERDR_ENV:-}" = "1" ] && command -v herdr >/dev/null 2>&1; then
	live="$(herdr agent list 2>/dev/null | grep -c "pi" || true)"
	if [ "$live" -gt 0 ]; then
		echo "precheck: $live live pi agent(s) in Herdr"
		exit 6
	fi
fi

echo "precheck: $next is ready"
exit 0
