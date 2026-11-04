# Pi OpenAI Fast Default Implementation Plan

> **For agentic workers:** Use superpowers:subagent-driven-development or superpowers:executing-plans. Track each step below.

**Goal:** Enable fast mode by default for supported OpenAI and ChatGPT models in Pi.

**Architecture:** Use the installed pi-fast-lane extension and its global JSON configuration. Merge repository defaults into a writable home file during settings synchronization. Do not link mutable extension state into Git.

**Tech Stack:** Bash, jq, GNU Stow, pi-fast-lane 0.2.3.

**Spec:** The approved design appears below.

## Approved Design

The owner approved this scope on 2026-11-04:
- Enable fast mode for supported openai and openai-codex models.
- Exclude Claude models from fast mode. Keep thinking levels unchanged.
- Preserve the /fast command and its saved selection between normal Pi sessions.
- Accept the stated fast-mode cost increase.

### Approaches

Use the existing extension configuration. A shell alias misses direct and child launches. A new extension duplicates installed behavior.

### Configuration and State

Store defaults at pi/.pi/agent/extensions/pi-fast-lane.json. Set persistState and desiredActive to true.
Use all nine OpenAI entries from the installed extension's default list, without its three Anthropic entries.
The source has four openai entries and five openai-codex entries, including openai-codex/gpt-6-sol.
Exclude this file from Stow. Extend scripts/apply-pi-settings.sh to merge its defaults into the target settings directory's extensions file.
Preserve unrelated local extension keys. Settings synchronization restores the repository defaults, including desiredActive=true.
Normal Pi restarts preserve the local /fast selection. Project configuration and inherited child state keep their extension-defined precedence.
If a custom source settings file has no sibling extension defaults, preserve current script behavior.

## Feasibility Evidence

The installed extension reads global configuration from ~/.pi/agent/extensions/pi-fast-lane.json.
Its startup resolver uses desiredActive only when persistState=true.
Its store writes through symlinks with writeFile, so a Stow link would change the repository after /fast.
Its supportedModels list uses exact provider/model keys and replaces the built-in list.
No network request or paid model call is needed to verify the configuration change.

## Global Constraints

- Do not change providers, model IDs, thinking levels, or package versions.
- Do not change unrelated work in the main checkout.
- Use short English sentences in new documentation and messages.
- Do not send paid model requests during tests.

## Review Focus

- Fresh home: defaults enable OpenAI fast mode without a Stow conflict.
- Existing home: managed defaults replace stale values and preserve unrelated keys.
- Runtime writes: /fast state stays outside Git and survives normal Pi restarts.
- Custom source: absent extension defaults do not affect existing callers.
- Model scope: Claude stays outside the fast-mode list and all nine OpenAI entries remain present.

## Task 1: Configure OpenAI Fast Defaults

**Files:**
- Create pi/.pi/agent/extensions/pi-fast-lane.json.
- Change pi/.stow-local-ignore and scripts/apply-pi-settings.sh.
- Change tests/pi-settings.sh and tests/pi-home.sh as needed.
- Change README.md with usage, synchronization, precedence, and cost notes.

**Interfaces:** The settings script keeps its two positional arguments. Its source settings directory supplies optional extension defaults.

- [x] Add regression tests for the five review conditions. Use repository configuration in assertions, not a duplicate model list alone.
- [x] Run the tests and record the expected missing-default failure before implementation.
- [x] Add the minimal configuration, writable-file merge, and Stow exclusion. Validate JSON objects before replacement.
- [x] Run bash tests/pi-settings.sh, bash tests/pi-home.sh, and bash tests/pi-agent-budget.sh. Run ShellCheck on changed shell files.
- [x] Update README.md and record test results in the task report.
- [x] Commit the task with a conventional commit message.

## Publication

- [ ] Get one task review and resolve supported findings.
- [ ] Get one final whole-branch review on the session model.
- [ ] Push the branch and create a pull request. Do not merge locally.
- [ ] Remove the worktree only after all commits reach the remote.

The owner approved the scope already. No further owner decision is open.
