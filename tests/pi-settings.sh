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
  "subagents": {"defaultModel": "openai/gpt-6-luna", "defaultThinking": "high", "agentOverrides": {"worker": {"timeoutMs": 5400000}}},
  "npmCommand": ["npm"],
  "theme": "rose-pine",
  "tokenSpeed": {"display": "full", "useProviderTokens": true},
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
  .subagents.defaultThinking == "high" and
  .subagents.agentOverrides.worker.timeoutMs == 5400000 and
  .tokenSpeed.useProviderTokens == true and
  .customTool.enabled == true and
  .lastChangelogVersion == "local-runtime-state"
' "$user_settings" >/dev/null || fail "managed settings must merge while preserving local keys"

# The repository extension defaults must enable only the nine supported OpenAI models.
fast_defaults="$ROOT_DIR/pi/.pi/agent/extensions/pi-fast-lane.json"
jq -e '
  .persistState == true and
  .desiredActive == true and
  (.supportedModels | length) == 9 and
  all(.supportedModels[]; startswith("openai/") or startswith("openai-codex/")) and
  ([.supportedModels[] | select(startswith("anthropic/"))] | length) == 0 and
  ([.supportedModels[] | select(startswith("openai/"))] | length) == 4 and
  ([.supportedModels[] | select(startswith("openai-codex/"))] | length) == 5 and
  (.supportedModels | index("openai-codex/gpt-6-sol") != null)
' "$fast_defaults" >/dev/null || fail "repository fast defaults must cover all nine OpenAI models only"

extension_target="$TMP_DIR/extensions/pi-fast-lane.json"
mkdir -p "$(dirname "$extension_target")"
printf '{"desiredActive":false,"customLocal":"keep","supportedModels":["stale/model"]}\n' >"$extension_target"
"$ROOT_DIR/scripts/apply-pi-settings.sh" "$ROOT_DIR/pi/.pi/agent/settings.json" "$user_settings"
jq -e '
  .persistState == true and .desiredActive == true and .customLocal == "keep" and
  (.supportedModels == input.supportedModels)
' "$extension_target" "$fast_defaults" >/dev/null || fail "extension defaults must replace managed values and preserve local keys"
[ ! -L "$extension_target" ] || fail "runtime extension config must be a writable real file"

before="$(shasum -a 256 "$user_settings")"
"$ROOT_DIR/scripts/apply-pi-settings.sh" "$ROOT_DIR/pi/.pi/agent/settings.json" "$user_settings"
after="$(shasum -a 256 "$user_settings")"
[ "$before" = "$after" ] || fail "a second apply must not change the file"

# A custom settings source without sibling extension defaults must not touch extensions.
custom_source="$TMP_DIR/custom/source/settings.json"
custom_target="$TMP_DIR/custom/home/settings.json"
mkdir -p "$(dirname "$custom_source")"
printf '{"theme":"custom"}\n' >"$custom_source"
"$ROOT_DIR/scripts/apply-pi-settings.sh" "$custom_source" "$custom_target"
[ ! -e "$TMP_DIR/custom/home/extensions/pi-fast-lane.json" ] ||
	fail "a custom source without extension defaults must keep existing behavior"

# Malformed extension source and target objects must fail before any target replacement.
malformed_source="$TMP_DIR/malformed/source/settings.json"
malformed_target="$TMP_DIR/malformed/home/settings.json"
mkdir -p "$(dirname "$malformed_source")" "$(dirname "$malformed_target")/extensions"
printf '{"theme":"managed"}\n' >"$malformed_source"
mkdir -p "$(dirname "$malformed_source")/extensions"
printf '{"desiredActive":true}\n' >"$(dirname "$malformed_source")/extensions/pi-fast-lane.json"
printf '{"theme":"local"}\n' >"$malformed_target"
printf '[1,2,3]\n' >"$(dirname "$malformed_target")/extensions/pi-fast-lane.json"
settings_before="$(shasum -a 256 "$malformed_target")"
if "$ROOT_DIR/scripts/apply-pi-settings.sh" "$malformed_source" "$malformed_target" >"$TMP_DIR/malformed.out" 2>&1; then
	fail "a non-object extension target must fail"
fi
[ "$settings_before" = "$(shasum -a 256 "$malformed_target")" ] ||
	fail "malformed extension target must not replace settings"
printf '{"desiredActive":true}\n' >"$(dirname "$malformed_target")/extensions/pi-fast-lane.json"
printf '[]\n' >"$(dirname "$malformed_source")/extensions/pi-fast-lane.json"
if "$ROOT_DIR/scripts/apply-pi-settings.sh" "$malformed_source" "$malformed_target" >"$TMP_DIR/malformed.out" 2>&1; then
	fail "a non-object extension source must fail"
fi
[ "$settings_before" = "$(shasum -a 256 "$malformed_target")" ] ||
	fail "malformed extension source must not replace settings"

new_settings="$TMP_DIR/new/nested/settings.json"
"$ROOT_DIR/scripts/apply-pi-settings.sh" "$repo_settings" "$new_settings"
jq -e '
  .defaultModel == "gpt-6-luna" and
  .customTool == null and
  .lastChangelogVersion == null
' "$new_settings" >/dev/null || fail "a missing target must be created without copying runtime state"

# Fake Pi agent directory so the on-disk check sees the fixture packages.
agent_dir="$TMP_DIR/agent"
mkdir -p "$agent_dir/npm/node_modules/alpha" "$agent_dir/npm/node_modules/@scope/alpha" \
	"$agent_dir/git/github.com/example/beta"
export PI_AGENT_DIR="$agent_dir"

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

cat >"$repo_status" <<'JSON'
{"packages": ["npm:alpha@1.0.0", "npm:gamma"]}
JSON
cp "$repo_status" "$actual_status"
if PI_REPO_SETTINGS="$repo_status" PI_SETTINGS_FILE="$actual_status" \
	"$ROOT_DIR/scripts/pi-status.sh" >"$TMP_DIR/status.out"; then
	fail "a declared package that is missing on disk must return non-zero"
fi
grep -F "not-installed: npm:gamma ($agent_dir/npm/node_modules/gamma)" "$TMP_DIR/status.out" >/dev/null ||
	fail "a package missing on disk must be reported with its expected path"

# sync-pi-packages.sh installs only what is declared in the repository and absent locally.
fake_bin="$TMP_DIR/bin"
mkdir -p "$fake_bin"
cat >"$fake_bin/pi" <<'SH'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"${PI_FAKE_LOG:?}"
SH
chmod +x "$fake_bin/pi"
cat >"$repo_status" <<'JSON'
{"packages": ["npm:alpha@1.0.0", "npm:gamma", "git:github.com/example/delta", {"source": "npm:@scope/alpha@1.0.0"}]}
JSON
cat >"$actual_status" <<'JSON'
{"packages": ["npm:alpha@1.0.0", "npm:gamma", {"source": "npm:@scope/alpha@1.0.0"}]}
JSON
PI_FAKE_LOG="$TMP_DIR/pi.log" PI_BIN="$fake_bin/pi" PI_REPO_SETTINGS="$repo_status" PI_SETTINGS_FILE="$actual_status" \
	"$ROOT_DIR/scripts/sync-pi-packages.sh" >"$TMP_DIR/sync.out" || fail "sync must succeed with a working pi"
grep -Fx 'install npm:gamma' "$TMP_DIR/pi.log" >/dev/null ||
	fail "a declared package missing on disk must be installed"
grep -Fx 'install git:github.com/example/delta' "$TMP_DIR/pi.log" >/dev/null ||
	fail "a package absent from the local settings must be installed"
if grep -F 'alpha' "$TMP_DIR/pi.log" >/dev/null; then
	fail "packages that are declared and present on disk must not be reinstalled"
fi
grep -F '2 installed, 2 already present' "$TMP_DIR/sync.out" >/dev/null || fail "sync must report its counts"

echo "PASS: Pi settings merge, idempotence, drift reporting, and package sync"
