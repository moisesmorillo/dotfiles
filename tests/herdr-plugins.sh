#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

fail() {
	echo "FAIL: $*" >&2
	exit 1
}

# sync-herdr-plugins.sh installs only what is declared in the repository and absent
# from Herdr's registry, passing --ref when the manifest pins one.
fake_bin="$TMP_DIR/bin"
mkdir -p "$fake_bin"
cat >"$fake_bin/herdr" <<'SH'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"${HERDR_FAKE_LOG:?}"
SH
chmod +x "$fake_bin/herdr"

manifest="$TMP_DIR/plugins.txt"
registry="$TMP_DIR/plugins.json"
cat >"$manifest" <<'TXT'
# comment line

kryptamine/herdr-auto-title@v0.13.2   # pinned and already installed
example/pinned-plugin@v1.2.3
example/unpinned-plugin
example/monorepo/plugins/sub@main
TXT
cat >"$registry" <<'JSON'
[
  {"plugin_id": "herdr.auto-title", "source": {"kind": "github", "owner": "kryptamine", "repo": "herdr-auto-title"}}
]
JSON

HERDR_FAKE_LOG="$TMP_DIR/herdr.log" HERDR_BIN="$fake_bin/herdr" HERDR_REPO_MANIFEST="$manifest" HERDR_PLUGINS_FILE="$registry" \
	"$ROOT_DIR/scripts/sync-herdr-plugins.sh" >"$TMP_DIR/sync.out" || fail "sync must succeed with a working herdr"
grep -Fx 'plugin install example/pinned-plugin --ref v1.2.3 --yes' "$TMP_DIR/herdr.log" >/dev/null ||
	fail "a pinned plugin must be installed with its ref"
grep -Fx 'plugin install example/unpinned-plugin --yes' "$TMP_DIR/herdr.log" >/dev/null ||
	fail "an unpinned plugin must be installed without --ref"
grep -Fx 'plugin install example/monorepo/plugins/sub --ref main --yes' "$TMP_DIR/herdr.log" >/dev/null ||
	fail "a subdirectory source must keep its path and ref"
if grep -F 'herdr-auto-title' "$TMP_DIR/herdr.log" >/dev/null; then
	fail "plugins already present in plugins.json must not be reinstalled"
fi
grep -F '3 installed, 1 already present' "$TMP_DIR/sync.out" >/dev/null || fail "sync must report its counts"
grep -F 'restart' "$TMP_DIR/sync.out" >/dev/null || fail "sync must say how to activate new plugins"

# A missing registry means nothing is installed yet (fresh machine).
: >"$TMP_DIR/herdr2.log"
HERDR_FAKE_LOG="$TMP_DIR/herdr2.log" HERDR_BIN="$fake_bin/herdr" HERDR_REPO_MANIFEST="$manifest" \
	HERDR_PLUGINS_FILE="$TMP_DIR/does-not-exist.json" \
	"$ROOT_DIR/scripts/sync-herdr-plugins.sh" >"$TMP_DIR/sync2.out" || fail "sync must succeed without a registry"
grep -F '4 installed, 0 already present' "$TMP_DIR/sync2.out" >/dev/null ||
	fail "without a registry every declared plugin must be installed"

# A malformed spec fails loudly instead of calling herdr with garbage.
printf 'not-a-source\n' >"$TMP_DIR/bad.txt"
: >"$TMP_DIR/herdr3.log"
if HERDR_FAKE_LOG="$TMP_DIR/herdr3.log" HERDR_BIN="$fake_bin/herdr" HERDR_REPO_MANIFEST="$TMP_DIR/bad.txt" \
	HERDR_PLUGINS_FILE="$registry" "$ROOT_DIR/scripts/sync-herdr-plugins.sh" >/dev/null 2>"$TMP_DIR/bad.err"; then
	fail "an invalid spec must make the sync fail"
fi
grep -F 'invalid plugin spec' "$TMP_DIR/bad.err" >/dev/null || fail "an invalid spec must be named in the error"
[ ! -s "$TMP_DIR/herdr3.log" ] || fail "an invalid spec must not reach herdr"

echo "PASS: Herdr plugin sync installs missing declared plugins with their refs"
