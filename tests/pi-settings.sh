#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

fail() {
	echo "FAIL: $*" >&2
	exit 1
}

repo_settings="$TMP_DIR/repo-settings.json"
user_settings="$TMP_DIR/user-settings.json"
cat >"$repo_settings" <<'JSON'
{
  "defaultModel": "gpt-6-luna",
  "defaultProvider": "openai",
  "defaultThinkingLevel": "medium",
  "modelThinkingLevels": {"openai/gpt-6-luna": "medium"},
  "packages": ["npm:example@1.2.3"],
  "skills": ["~/skills"],
  "npmCommand": ["npm"],
  "theme": "rose-pine",
  "lastChangelogVersion": "should-not-copy"
}
JSON
cat >"$user_settings" <<'JSON'
{
  "defaultModel": "old-model",
  "packages": ["npm:old-package@1.0.0"],
  "theme": "old-theme",
  "customTool": {"enabled": true},
  "lastChangelogVersion": "local-runtime-state"
}
JSON

"$ROOT_DIR/scripts/apply-pi-settings.sh" "$repo_settings" "$user_settings"
jq -e '
  .defaultModel == "gpt-6-luna" and
  .defaultThinkingLevel == "medium" and
  .packages == ["npm:example@1.2.3"] and
  .customTool.enabled == true and
  .lastChangelogVersion == "local-runtime-state"
' "$user_settings" >/dev/null || fail "managed settings must merge while preserving local keys"

before="$(shasum -a 256 "$user_settings")"
"$ROOT_DIR/scripts/apply-pi-settings.sh" "$repo_settings" "$user_settings"
after="$(shasum -a 256 "$user_settings")"
[ "$before" = "$after" ] || fail "a second apply must not change the file"

new_settings="$TMP_DIR/new/nested/settings.json"
"$ROOT_DIR/scripts/apply-pi-settings.sh" "$repo_settings" "$new_settings"
jq -e '
  .defaultModel == "gpt-6-luna" and
  .customTool == null and
  .lastChangelogVersion == null
' "$new_settings" >/dev/null || fail "a missing target must be created without copying runtime state"

repo_status="$TMP_DIR/status-repo.json"
actual_status="$TMP_DIR/status-actual.json"
cat >"$repo_status" <<'JSON'
{"packages": ["npm:alpha@1.0.0", "git:github.com/example/beta@0123456789012345678901234567890123456789"]}
JSON
cp "$repo_status" "$actual_status"
PI_REPO_SETTINGS="$repo_status" PI_SETTINGS_FILE="$actual_status" \
	"$ROOT_DIR/scripts/pi-status.sh" >/dev/null || fail "matching packages must report clean"

cat >"$actual_status" <<'JSON'
{"packages": ["npm:alpha@2.0.0", "npm:extra@1.0.0", "git:github.com/example/beta@main"]}
JSON
if PI_REPO_SETTINGS="$repo_status" PI_SETTINGS_FILE="$actual_status" \
	"$ROOT_DIR/scripts/pi-status.sh" >"$TMP_DIR/status.out"; then
	fail "package drift must return non-zero"
fi
grep -F 'version-mismatch: npm:alpha@1.0.0 (installed: npm:alpha@2.0.0)' "$TMP_DIR/status.out" >/dev/null ||
	fail "version mismatch must identify both npm versions"
grep -F 'version-mismatch: git:github.com/example/beta@0123456789012345678901234567890123456789 (installed: git:github.com/example/beta@main)' \
	"$TMP_DIR/status.out" >/dev/null || fail "Git refs must be classified as a version mismatch"
grep -F 'extra: npm:extra@1.0.0' "$TMP_DIR/status.out" >/dev/null || fail "extra package must be reported"

cat >"$actual_status" <<'JSON'
{"packages": ["npm:alpha@1.0.0", "npm:alpha@2.0.0"]}
JSON
if PI_REPO_SETTINGS="$repo_status" PI_SETTINGS_FILE="$actual_status" \
	"$ROOT_DIR/scripts/pi-status.sh" >"$TMP_DIR/status.out"; then
	fail "a duplicate package with a conflicting version must return non-zero"
fi
grep -F 'npm:alpha@2.0.0' "$TMP_DIR/status.out" >/dev/null || fail "conflicting duplicate must be reported"

cat >"$repo_status" <<'JSON'
{"packages": ["npm:@scope/alpha@1.0.0"]}
JSON
cat >"$actual_status" <<'JSON'
{"packages": [{"source": "npm:@scope/alpha@1.0.0", "extensions": []}]}
JSON
PI_REPO_SETTINGS="$repo_status" PI_SETTINGS_FILE="$actual_status" \
	"$ROOT_DIR/scripts/pi-status.sh" >/dev/null || fail "Pi object package declarations must compare by source"

cat >"$repo_status" <<'JSON'
{"packages": []}
JSON
cat >"$actual_status" <<'JSON'
{"packages": ["git:github.com/extra/package@main"]}
JSON
if PI_REPO_SETTINGS="$repo_status" PI_SETTINGS_FILE="$actual_status" \
	"$ROOT_DIR/scripts/pi-status.sh" >"$TMP_DIR/status.out"; then
	fail "an unpinned Git package must not be silently ignored"
fi
grep -F 'extra: git:github.com/extra/package@main' "$TMP_DIR/status.out" >/dev/null ||
	fail "unversioned Git package must be reported as extra"

echo "PASS: Pi settings merge, idempotence, and drift reporting"
