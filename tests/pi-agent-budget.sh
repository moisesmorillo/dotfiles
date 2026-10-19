#!/usr/bin/env bash
# Exercises the pure decision functions of pi/.pi/agent/extensions/agent-budget.ts
# with Node's native TypeScript stripping. No pi runtime is needed.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXT="$ROOT_DIR/pi/.pi/agent/extensions/agent-budget.ts"

fail() {
	echo "FAIL: $*" >&2
	exit 1
}

[ -f "$EXT" ] || fail "extension missing: $EXT"

NODE=(node)
if command -v mise >/dev/null 2>&1; then
	NODE=(mise exec node@24 -- node)
fi

"${NODE[@]}" --input-type=module -e "
import { clampLogBytes, decideMemorySave, pruneActiveTools, MAX_LOG_BYTES } from '$EXT';

const assert = (ok, msg) => { if (!ok) { console.error('FAIL: ' + msg); process.exit(1); } };

// bg_logs: a large or missing maxBytes is clamped, a small one is kept.
assert(clampLogBytes({ taskId: 'a', maxBytes: 50000 }).maxBytes === MAX_LOG_BYTES, 'large maxBytes clamps');
assert(clampLogBytes({ taskId: 'a' }).maxBytes === MAX_LOG_BYTES, 'missing maxBytes clamps');
assert(clampLogBytes({ taskId: 'a', maxBytes: 800 }).maxBytes === 800, 'small maxBytes kept');
assert(clampLogBytes({ taskId: 'a', maxBytes: 800 }).taskId === 'a', 'other fields kept');

// mem_save: the first save of a topic passes, a repeat inside the window is blocked.
const t0 = 1_000_000;
const ledger = new Map();
let d = decideMemorySave(ledger, { title: 'A', topic_key: 'k1' }, t0);
assert(d.block === false, 'first topic save passes');
d = decideMemorySave(ledger, { title: 'B', topic_key: 'k1' }, t0 + 60_000);
assert(d.block === true && /k1/.test(d.reason), 'repeat topic inside window blocks');
d = decideMemorySave(ledger, { title: 'C', topic_key: 'k1' }, t0 + 31 * 60_000);
assert(d.block === false, 'repeat topic after window passes');

// mem_save: more than the hourly budget is blocked, whatever the topic.
const ledger2 = new Map();
for (let i = 0; i < 6; i++) {
  assert(decideMemorySave(ledger2, { title: 'T' + i }, t0 + i * 1000).block === false, 'save ' + i + ' within budget');
}
d = decideMemorySave(ledger2, { title: 'T7' }, t0 + 7000);
assert(d.block === true && /budget/i.test(d.reason), 'seventh save in an hour blocks');
d = decideMemorySave(ledger2, { title: 'T8' }, t0 + 61 * 60_000);
assert(d.block === false, 'budget resets after an hour');

// ste_lint is removed from the active tools, everything else stays.
const pruned = pruneActiveTools(['read', 'say', 'ste_lint', 'edit']);
assert(JSON.stringify(pruned) === JSON.stringify(['read', 'edit']), 'ste_lint and say pruned');
assert(pruneActiveTools(['read']) === null, 'no change returns null');

console.log('pi-agent-budget: ok');
"
