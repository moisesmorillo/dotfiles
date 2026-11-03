#!/usr/bin/env bash
# Start one pi session on the next ready Backlog.md subtask of a gate task.
# Orca: creates a terminal in the repository worktree and sends the kickoff line.
# herdr-core (hc): starts pi as terminal pi-<gate> in a herdr-app tab and sends the kickoff line
# (not yet verified on a live core).
# The Orca automation runs this script after its own precheck. Set SKIP_PRECHECK=1 there,
# because the automation run sees itself as a live pi session.
set -euo pipefail

REPO="${1:?usage: agent-next-task.sh <repo-path> <gate-task-id> [kickoff-text]}"
GATE="${2:?usage: agent-next-task.sh <repo-path> <gate-task-id> [kickoff-text]}"
KICKOFF="${3:-Pick the next ready $GATE subtask and do it. Read the Session start section of AGENTS.md first.}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ORCA_BIN="${ORCA_BIN:-orca}"
PI_COMMAND="${PI_COMMAND:-pi --fast}"

if [ "${SKIP_PRECHECK:-0}" != "1" ]; then
	"$SCRIPT_DIR/backlog-next-task-precheck.sh" "$REPO" "$GATE"
fi

if [ -n "${ORCA_TERMINAL_HANDLE:-}" ] || "$ORCA_BIN" status >/dev/null 2>&1; then
	handle="$("$ORCA_BIN" terminal create --worktree "path:$REPO" --title "pi $GATE" --command "$PI_COMMAND" --json \
		| jq -r '.result.terminal.handle')"
	[ -n "$handle" ] && [ "$handle" != "null" ] || { echo "agent-next-task: Orca did not return a terminal handle" >&2; exit 1; }
	"$ORCA_BIN" terminal wait --terminal "$handle" --for tui-idle --timeout-ms 60000 >/dev/null
	"$ORCA_BIN" terminal send --terminal "$handle" --text $'\r' >/dev/null
	sleep 2
	"$ORCA_BIN" terminal wait --terminal "$handle" --for tui-idle --timeout-ms 30000 >/dev/null || true
	"$ORCA_BIN" terminal send --terminal "$handle" --text "$KICKOFF"$'\r' >/dev/null
	echo "agent-next-task: started pi in Orca terminal $handle"
	exit 0
fi

HC_BIN="${HC_BIN:-hc}"
if command -v "$HC_BIN" >/dev/null 2>&1 && "$HC_BIN" ls >/dev/null 2>&1; then
	# herdr-app shows a terminal with the labels herdr.space and herdr.tab in that space
	# and tab. Inside an hc terminal, pi goes to the caller's space. Elsewhere it goes to a
	# space of its own. An unknown tab id becomes a new tab.
	space="sp-pi"
	if [ -n "${HC_TERMINAL_ID:-}" ]; then
		s="$("$HC_BIN" get "$HC_TERMINAL_ID" --json 2>/dev/null | jq -r '.labels["herdr.space"] // empty' || true)"
		[ -z "$s" ] || space="$s"
	fi
	name="pi-$GATE"
	# --outlive-parent: started from an agent's terminal, pi would otherwise end with it.
	# shellcheck disable=SC2086
	"$HC_BIN" run --bg --keep --outlive-parent --name "$name" --cwd "$REPO" \
		--label "herdr.space=$space" --label "herdr.tab=tb-$name" -- $PI_COMMAND >/dev/null
	# `hc send` waits for a pause in the output, pastes the text and presses Enter.
	"$HC_BIN" send "$name" "$KICKOFF" >/dev/null || true
	echo "agent-next-task: started pi in herdr-core terminal $name"
	exit 0
fi

echo "agent-next-task: no harness found (Orca or herdr-core). Start pi in $REPO and send: $KICKOFF" >&2
exit 1
