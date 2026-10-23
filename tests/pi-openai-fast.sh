#!/usr/bin/env bash
# Exercises the pure functions of pi/.pi/agent/extensions/openai-fast.ts
# with Node's native TypeScript stripping. No pi runtime is needed.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXT="$ROOT_DIR/pi/.pi/agent/extensions/openai-fast.ts"

fail() {
	echo "FAIL: $*" >&2
	exit 1
}

[ -f "$EXT" ] || fail "extension missing: $EXT"

NODE=(node)
if command -v mise >/dev/null 2>&1; then
	NODE=(mise exec node@24 -- node)
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

"${NODE[@]}" --input-type=module -e "
import { applyFastTier, isOpenAiPayload, parseFastCommand, readToggle, writeToggle, PRIORITY_TIER } from '$EXT';

const assert = (ok, msg) => { if (!ok) { console.error('FAIL: ' + msg); process.exit(1); } };

// Only OpenAI bodies qualify.
assert(isOpenAiPayload({ model: 'gpt-6.1-sol', input: [] }), 'gpt model qualifies');
assert(!isOpenAiPayload({ model: 'claude-fable-5-1', messages: [] }), 'claude model does not qualify');
assert(!isOpenAiPayload(null) && !isOpenAiPayload([1]), 'non-object bodies do not qualify');

// The tier is added only when the toggle is on and no tier is set.
const body = { model: 'gpt-6-luna', input: [] };
assert(applyFastTier(body, false) === body, 'off returns the same body');
assert(applyFastTier(body, true).service_tier === PRIORITY_TIER, 'on adds the priority tier');
assert(applyFastTier({ model: 'gpt-6-luna', service_tier: 'flex' }, true).service_tier === 'flex', 'an explicit tier wins');
assert(applyFastTier({ model: 'claude-fable-5-1' }, true).service_tier === undefined, 'other providers untouched');

// Command parsing.
assert(parseFastCommand('on') === 'on' && parseFastCommand(' OFF ') === 'off', 'on and off parse');
assert(parseFastCommand('') === 'status' && parseFastCommand(undefined) === 'status', 'empty means status');

// Toggle persistence. A missing file means off.
const path = '$TMP/openai-fast.json';
assert(readToggle(path) === false, 'missing file is off');
writeToggle(true, path);
assert(readToggle(path) === true, 'written toggle reads back on');
writeToggle(false, path);
assert(readToggle(path) === false, 'written toggle reads back off');
console.log('ok');
" || fail "pure function checks failed"

echo "pi-openai-fast: ok"
