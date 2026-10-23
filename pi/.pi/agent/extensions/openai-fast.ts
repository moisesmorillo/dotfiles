/**
 * openai-fast: a `/fast` toggle for the OpenAI priority service tier.
 *
 * ChatGPT exposes a "fast" mode that answers sooner and uses more of the
 * subscription allowance. The OpenAI Responses API exposes the same thing as
 * `service_tier: "priority"`. Pi has no setting for it, so this extension adds
 * the field to every OpenAI request while the toggle is on. The toggle lives in
 * `~/.pi/agent/openai-fast.json`, so it survives a restart and applies to every
 * session on this machine. Pi prices a priority response at two times the
 * standard rate, which the session footer shows.
 */
import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

/** Service tier value that the OpenAI Responses API treats as fast processing. */
export const PRIORITY_TIER = "priority";

/** Path of the persisted toggle. */
export const STATE_PATH = join(homedir(), ".pi", "agent", "openai-fast.json");

type Payload = Record<string, unknown>;

/** Returns true when the request body is an OpenAI chat or responses request. */
export function isOpenAiPayload(payload: unknown): payload is Payload {
	if (!payload || typeof payload !== "object" || Array.isArray(payload)) return false;
	const model = (payload as Payload).model;
	return typeof model === "string" && /^(gpt-|o\d|codex)/.test(model);
}

/**
 * Returns the request body with the priority tier when the toggle is on.
 * A body that already names a tier is returned unchanged, so an explicit
 * per-request choice wins.
 */
export function applyFastTier(payload: unknown, enabled: boolean): unknown {
	if (!enabled || !isOpenAiPayload(payload)) return payload;
	if ("service_tier" in payload) return payload;
	return { ...payload, service_tier: PRIORITY_TIER };
}

/** Reads the toggle. A missing or unreadable file means off. */
export function readToggle(path: string = STATE_PATH): boolean {
	try {
		if (!existsSync(path)) return false;
		const parsed = JSON.parse(readFileSync(path, "utf8")) as { enabled?: unknown };
		return parsed.enabled === true;
	} catch {
		return false;
	}
}

/** Writes the toggle. */
export function writeToggle(enabled: boolean, path: string = STATE_PATH): void {
	writeFileSync(path, `${JSON.stringify({ enabled }, null, 2)}\n`);
}

/** Parses the `/fast` argument. An empty argument reports the current state. */
export function parseFastCommand(arg: string | undefined): "on" | "off" | "status" {
	const word = (arg ?? "").trim().toLowerCase();
	if (word === "on" || word === "1" || word === "true") return "on";
	if (word === "off" || word === "0" || word === "false") return "off";
	return "status";
}

export default function openaiFast(pi: ExtensionAPI) {
	let enabled = readToggle();

	const show = (ctx: { hasUI: boolean; ui: { setStatus: (k: string, v: string) => void; notify: (m: string, l: string) => void } }, notify: boolean) => {
		if (!ctx.hasUI) return;
		ctx.ui.setStatus("fast", enabled ? "fast: on" : "");
		if (notify) ctx.ui.notify(enabled ? "OpenAI fast mode on. Priority tier, two times the allowance." : "OpenAI fast mode off.", "info");
	};

	pi.registerCommand("fast", {
		description: "Toggle the OpenAI priority tier: /fast on | off | status",
		handler: async (arg: string, ctx) => {
			const action = parseFastCommand(arg);
			if (action !== "status") {
				enabled = action === "on";
				writeToggle(enabled);
			}
			show(ctx, true);
		},
	});

	pi.on("before_agent_start", (_event, ctx) => {
		enabled = readToggle();
		show(ctx, false);
	});

	pi.on("before_provider_request", (event: { payload?: unknown }) => {
		return applyFastTier(event.payload, enabled);
	});
}
