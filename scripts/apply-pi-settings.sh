#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
SOURCE_SETTINGS="${1:-$ROOT_DIR/pi/.pi/agent/settings.json}"
TARGET_SETTINGS="${2:-$HOME/.pi/agent/settings.json}"

if ! command -v jq >/dev/null 2>&1; then
	echo "apply-pi-settings: jq is required" >&2
	exit 1
fi
if [ ! -f "$SOURCE_SETTINGS" ]; then
	echo "apply-pi-settings: source settings not found: $SOURCE_SETTINGS" >&2
	exit 1
fi
jq -e 'type == "object"' "$SOURCE_SETTINGS" >/dev/null || {
	echo "apply-pi-settings: source settings must be a JSON object" >&2
	exit 1
}

mkdir -p "$(dirname "$TARGET_SETTINGS")"
if [ -f "$TARGET_SETTINGS" ]; then
	jq -e 'type == "object"' "$TARGET_SETTINGS" >/dev/null || {
		echo "apply-pi-settings: target settings must be a JSON object: $TARGET_SETTINGS" >&2
		exit 1
	}
else
	printf '{}\n' >"$TARGET_SETTINGS"
fi

TEMP_SETTINGS="$(mktemp "$(dirname "$TARGET_SETTINGS")/.settings.json.XXXXXX")"
trap 'rm -f "$TEMP_SETTINGS"' EXIT
jq -s '
	.[0] as $current |
	.[1] as $repository |
	["defaultModel", "defaultProvider", "defaultThinkingLevel", "modelThinkingLevels", "npmCommand", "packages", "skills", "theme", "tuiMode"] as $managed |
	($current // {}) * ($repository | with_entries(select(.key as $key | $managed | index($key))))
' "$TARGET_SETTINGS" "$SOURCE_SETTINGS" >"$TEMP_SETTINGS"

if ! cmp -s "$TEMP_SETTINGS" "$TARGET_SETTINGS"; then
	mv "$TEMP_SETTINGS" "$TARGET_SETTINGS"
fi
