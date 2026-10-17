#!/usr/bin/env bash
# Install every package declared in the repository's Pi settings that is not yet
# installed, so a fresh machine and a `fu` run converge on the same package set.
# Settings merging stays in apply-pi-settings.sh; this script only installs.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
# shellcheck source=scripts/pi-package-lib.sh
. "$SCRIPT_DIR/pi-package-lib.sh"

REPO_SETTINGS="${PI_REPO_SETTINGS:-$ROOT_DIR/pi/.pi/agent/settings.json}"
PI_AGENT_DIR="${PI_AGENT_DIR:-$HOME/.pi/agent}"
INSTALLED_SETTINGS="${PI_SETTINGS_FILE:-$PI_AGENT_DIR/settings.json}"
PI_BIN="${PI_BIN:-pi}"

if ! command -v jq >/dev/null 2>&1; then
	echo "sync-pi-packages: jq is required" >&2
	exit 1
fi
if ! command -v "$PI_BIN" >/dev/null 2>&1; then
	echo "sync-pi-packages: pi is not on PATH (run through mise exec or install pi first)" >&2
	exit 1
fi
if [ ! -f "$REPO_SETTINGS" ]; then
	echo "sync-pi-packages: repository settings not found: $REPO_SETTINGS" >&2
	exit 1
fi

declared_in_settings() {
	[ -f "$INSTALLED_SETTINGS" ] || return 1
	jq -e --arg spec "$1" '
		(.packages // [])
		| map(if type == "object" then .source else . end)
		| index($spec) != null
	' "$INSTALLED_SETTINGS" >/dev/null 2>&1
}

installed=0
skipped=0
while IFS= read -r spec; do
	[ -n "$spec" ] || continue
	path="$(pi_package_path "$spec" "$PI_AGENT_DIR")"
	if declared_in_settings "$spec" && { [ -z "$path" ] || [ -e "$path" ]; }; then
		skipped=$((skipped + 1))
		continue
	fi
	echo "sync-pi-packages: installing $spec"
	"$PI_BIN" install "$spec"
	installed=$((installed + 1))
done < <(jq -r '(.packages // [])[] | if type == "object" then .source else . end' "$REPO_SETTINGS")

echo "sync-pi-packages: $installed installed, $skipped already present"
