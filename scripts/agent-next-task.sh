#!/usr/bin/env bash
# Start one pi session on the next ready Backlog.md subtask of a gate task.
# Orca: creates a terminal in the repository worktree and sends the kickoff line.
# Herdr: creates a tab, starts pi in its pane and submits the kickoff line (not yet verified on a live server).
# The Orca automation does not use this script; it uses backlog-next-task-precheck.sh and its own launcher.
set -euo pipefail

REPO="${1:?usage: agent-next-task.sh <repo-path> <gate-task-id> [kickoff-text]}"
GATE="${2:?usage: agent-next-task.sh <repo-path> <gate-task-id> [kickoff-text]}"
KICKOFF="${3:-Pick the next ready $GATE subtask and do it. Read the Session start section of AGENTS.md first.}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ORCA_BIN="${ORCA_BIN:-orca}"
PI_COMMAND="${PI_COMMAND:-pi --fast}"

"$SCRIPT_DIR/backlog-next-task-precheck.sh" "$REPO" "$GATE"

if [ -n "${ORCA_TERMINAL_HANDLE:-}" ] || "$ORCA_BIN" status >/dev/null 2>&1; then
	handle="$("$ORCA_BIN" terminal create --worktree "path:$REPO" --title "pi $GATE" --command "$PI_COMMAND" --json \
		| jq -r '.result.terminal.handle')"
	[ -n "$handle" ] && [ "$handle" != "null" ] || { echo "agent-next-task: Orca did not return a terminal handle" >&2; exit 1; }
	"$ORCA_BIN" terminal wait --terminal "$handle" --for tui-idle --timeout 60000 >/dev/null
	"$ORCA_BIN" terminal send --terminal "$handle" --text $'\r' >/dev/null
	sleep 2
	"$ORCA_BIN" terminal wait --terminal "$handle" --for tui-idle --timeout 30000 >/dev/null || true
	"$ORCA_BIN" terminal send --terminal "$handle" --text "$KICKOFF"$'\r' >/dev/null
	echo "agent-next-task: started pi in Orca terminal $handle"
	exit 0
fi

if [ "${HERDR_ENV:-}" = "1" ] && command -v herdr >/dev/null 2>&1; then
	herdr tab create --cwd "$REPO" --label "pi $GATE" --focus >/dev/null
	pane="$(herdr pane current 2>/dev/null | awk 'NR==1{print $1}')"
	[ -n "$pane" ] || { echo "agent-next-task: Herdr did not return a pane id" >&2; exit 1; }
	# shellcheck disable=SC2086
	herdr agent start pi --kind pi --pane "$pane" -- ${PI_COMMAND#pi} >/dev/null
	herdr agent prompt "$pane" "$KICKOFF" --wait --timeout 30000 >/dev/null || true
	echo "agent-next-task: started pi in Herdr pane $pane"
	exit 0
fi

echo "agent-next-task: no harness found (Orca or Herdr). Start pi in $REPO and send: $KICKOFF" >&2
exit 1
