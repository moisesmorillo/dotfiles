/**
 * agent-budget: three deterministic guards for the orchestrator session.
 *
 * Why: the 2026-10-18 diagnosis of a six-day pi session showed that one third
 * of the cost went to `ste_lint` and `mem_save` calls, and that full `bg_logs`
 * reads (50 KiB each) caused half of the context compactions. Instruction text
 * in AGENTS.md competes with the text that the plugins inject, so these rules
 * run as code and cannot be argued with.
 *
 * 1. `ste_lint` is removed from the tools declared to the model. agent-ste still
 *    gates writes and commit messages in its own `tool_call` hook and still
 *    reports faults on replies, so nothing is lost.
 * 2. `bg_logs.maxBytes` is clamped to MAX_LOG_BYTES. The full output stays on
 *    disk under `.pi/tasks/`; the result points there when more bytes exist.
 * 3. `mem_save` is rate limited: one save per `topic_key` per TOPIC_WINDOW_MS
 *    and SAVE_BUDGET saves per BUDGET_WINDOW_MS. `mem_session_summary` is never
 *    touched. A blocked call returns a reason the model can act on.
 */
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

/** Upper bound, in bytes, for one model-visible `bg_logs` read. */
export const MAX_LOG_BYTES = 4096;
/** Minimum distance between two `mem_save` calls that share a `topic_key`. */
export const TOPIC_WINDOW_MS = 30 * 60_000;
/** Number of `mem_save` calls allowed inside one BUDGET_WINDOW_MS. */
export const SAVE_BUDGET = 6;
/** Sliding window for SAVE_BUDGET. */
export const BUDGET_WINDOW_MS = 60 * 60_000;
/** Tools removed from the model's declaration at session start. */
const PRUNED_TOOLS = new Set(["ste_lint"]);

type LogInput = { maxBytes?: unknown; [key: string]: unknown };
type SaveInput = { topic_key?: unknown; title?: unknown; [key: string]: unknown };
type Decision = { block: false } | { block: true; reason: string };

/**
 * Ledger of accepted saves. Key `all` holds every accepted timestamp in the
 * budget window; key `topic:<key>` holds the last accepted timestamp for that topic.
 */
export type MemoryLedger = Map<string, number[]>;

/** Returns a copy of the `bg_logs` input with `maxBytes` clamped to MAX_LOG_BYTES. */
export function clampLogBytes(input: LogInput): LogInput {
	const requested = typeof input.maxBytes === "number" && input.maxBytes > 0 ? input.maxBytes : MAX_LOG_BYTES;
	return { ...input, maxBytes: Math.min(requested, MAX_LOG_BYTES) };
}

/**
 * Decides whether a `mem_save` call passes. Accepted calls are recorded in the
 * ledger; blocked calls are not. `now` is injected so tests stay deterministic.
 */
export function decideMemorySave(ledger: MemoryLedger, input: SaveInput, now: number): Decision {
	const recent = (ledger.get("all") ?? []).filter((t) => now - t < BUDGET_WINDOW_MS);
	ledger.set("all", recent);
	if (recent.length >= SAVE_BUDGET) {
		const minutes = Math.ceil((BUDGET_WINDOW_MS - (now - recent[0])) / 60_000);
		return {
			block: true,
			reason:
				`Memory budget reached: ${SAVE_BUDGET} saves in the last hour. ` +
				`Fold this into the session summary instead. The budget frees in ${minutes} min.`,
		};
	}
	const topic = typeof input.topic_key === "string" && input.topic_key.length > 0 ? input.topic_key : undefined;
	if (topic) {
		const last = ledger.get(`topic:${topic}`)?.[0];
		if (last !== undefined && now - last < TOPIC_WINDOW_MS) {
			const minutes = Math.ceil((TOPIC_WINDOW_MS - (now - last)) / 60_000);
			return {
				block: true,
				reason:
					`Topic "${topic}" was saved ${Math.max(1, Math.round((now - last) / 60_000))} min ago. ` +
					`One save per topic per 30 min. Update it in ${minutes} min or in the session summary.`,
			};
		}
		ledger.set(`topic:${topic}`, [now]);
	}
	recent.push(now);
	return { block: false };
}

/** Returns the active tool list without PRUNED_TOOLS, or null when nothing changes. */
export function pruneActiveTools(active: string[]): string[] | null {
	const kept = active.filter((name) => !PRUNED_TOOLS.has(name));
	return kept.length === active.length ? null : kept;
}

export default function agentBudget(pi: ExtensionAPI) {
	const ledger: MemoryLedger = new Map();
	let blockedSaves = 0;

	pi.on("session_start", (_event, ctx) => {
		const pruned = pruneActiveTools(pi.getActiveTools());
		if (pruned) {
			pi.setActiveTools(pruned);
			if (ctx.hasUI) ctx.ui.setStatus("budget", "budget: lint tool off");
		}
		return undefined;
	});

	pi.on("tool_call", (event, ctx) => {
		if (event.toolName === "bg_logs") {
			// pi shares the input object with the tool, so an in-place change is enough.
			Object.assign(event.input, clampLogBytes(event.input as LogInput));
			return undefined;
		}
		if (event.toolName === "mem_save") {
			const decision = decideMemorySave(ledger, event.input as SaveInput, Date.now());
			if (decision.block) {
				blockedSaves += 1;
				if (ctx.hasUI) ctx.ui.setStatus("budget", `budget: ${blockedSaves} mem_save blocked`);
				return { block: true, reason: decision.reason };
			}
		}
		return undefined;
	});
}
