#!/usr/bin/env bash
# Install every Herdr plugin declared in herdr/plugins.txt that is not yet
# installed, so a fresh machine and a `fu` run converge on the same plugin set.
# Herdr keeps its own registry in ~/.config/herdr/plugins.json (machine-local
# paths, timestamps), so the repository declares sources and this script only
# installs what is missing. Lines: owner/repo[/subdir][@ref]; "#" starts a comment.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

REPO_MANIFEST="${HERDR_REPO_MANIFEST:-$ROOT_DIR/herdr/plugins.txt}"
PLUGINS_FILE="${HERDR_PLUGINS_FILE:-$HOME/.config/herdr/plugins.json}"
HERDR_BIN="${HERDR_BIN:-herdr}"

if ! command -v jq >/dev/null 2>&1; then
	echo "sync-herdr-plugins: jq is required" >&2
	exit 1
fi
if ! command -v "$HERDR_BIN" >/dev/null 2>&1; then
	echo "sync-herdr-plugins: herdr is not on PATH (run through mise exec or install herdr first)" >&2
	exit 1
fi
if [ ! -f "$REPO_MANIFEST" ]; then
	echo "sync-herdr-plugins: repository manifest not found: $REPO_MANIFEST" >&2
	exit 1
fi

# True when plugins.json already lists a GitHub install of owner/repo.
installed_from() {
	[ -f "$PLUGINS_FILE" ] || return 1
	jq -e --arg owner "$1" --arg repo "$2" '
		map(select(.source.kind == "github" and .source.owner == $owner and .source.repo == $repo))
		| length > 0
	' "$PLUGINS_FILE" >/dev/null 2>&1
}

installed=0
skipped=0
while IFS= read -r line; do
	spec="${line%%#*}"
	spec="${spec//[[:space:]]/}"
	[ -n "$spec" ] || continue
	ref=""
	source="$spec"
	case "$spec" in
	*@*)
		ref="${spec##*@}"
		source="${spec%@*}"
		;;
	esac
	owner="${source%%/*}"
	rest="${source#*/}"
	repo="${rest%%/*}"
	if [ -z "$owner" ] || [ -z "$repo" ] || [ "$owner" = "$source" ]; then
		echo "sync-herdr-plugins: invalid plugin spec: $spec" >&2
		exit 1
	fi
	if installed_from "$owner" "$repo"; then
		skipped=$((skipped + 1))
		continue
	fi
	echo "sync-herdr-plugins: installing $spec"
	if [ -n "$ref" ]; then
		"$HERDR_BIN" plugin install "$source" --ref "$ref" --yes
	else
		"$HERDR_BIN" plugin install "$source" --yes
	fi
	installed=$((installed + 1))
done <"$REPO_MANIFEST"

echo "sync-herdr-plugins: $installed installed, $skipped already present"
if [ "$installed" -gt 0 ]; then
	echo "sync-herdr-plugins: Herdr starts plugins with its server; run the plugin restart action" \
		"or \`herdr server stop\` before the next session to activate new ones"
fi
