#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
unset CLAUDE_CONFIG_DIR CODEX_HOME XDG_CONFIG_HOME XDG_STATE_HOME

fail() {
	echo "FAIL: $*" >&2
	exit 1
}

install_skill() {
	local home="$1"
	stow -d "$ROOT_DIR" -t "$home" agents
	HOME="$home" bash "$ROOT_DIR/scripts/link-terminal-browser-skill.sh"
}

fresh="$TMP_DIR/fresh"
mkdir -p "$fresh/.claude"
stow -d "$ROOT_DIR" -t "$fresh" claude
install_skill "$fresh"
[[ ! -L "$fresh/.claude" ]] || fail "Keep Claude state outside the Stow package"
source="$fresh/.config/agents/skills/terminal-browser/SKILL.md"
for path in .agents/skills .claude/skills; do
	[[ "$fresh/$path/terminal-browser/SKILL.md" -ef "$source" ]] || fail "$path must read the canonical skill"
done
[[ ! -L "$fresh/.agents/skills" && ! -L "$fresh/.claude/skills" ]] || fail "Keep parent skill directories writable"
install_skill "$fresh"
grep -Fxq no "$fresh/.local/state/terminal-browser/skills-choice" || fail "Disable vendor skill setup"

test_home="$TMP_DIR/existing"
vendor=/opt/homebrew/Caskroom/terminal-browser/0.16.3/terminal-browser/skills
mkdir -p "$test_home/.agents/skills" "$test_home/.claude" "$test_home/.codex/skills" \
	"$test_home/.gemini/skills" "$test_home/.config/opencode/skills"
ln -s ../.config/agents/skills "$test_home/.claude/skills"
ln -s "$vendor/default/terminal-browser" "$test_home/.agents/skills/terminal-browser"
ln -s "$vendor/codex/terminal-browser" "$test_home/.codex/skills/terminal-browser"
ln -s "$vendor/default/terminal-browser" "$test_home/.config/opencode/skills/terminal-browser"
ln -s /custom/skill "$test_home/.gemini/skills/terminal-browser"
printf 'keep this file\n' > "$test_home/.agents/skills/other.md"
install_skill "$test_home"
source="$test_home/.config/agents/skills/terminal-browser/SKILL.md"
for path in .agents/skills .claude/skills; do
	[[ "$test_home/$path/terminal-browser/SKILL.md" -ef "$source" ]] || fail "$path must read the canonical skill"
done
for path in .codex/skills .config/opencode/skills; do
	[[ ! -L "$test_home/$path/terminal-browser" ]] || fail "$path must not keep a Homebrew duplicate"
done
[[ "$(readlink "$test_home/.gemini/skills/terminal-browser")" == /custom/skill ]] || fail "Keep custom links"
grep -Fxq 'keep this file' "$test_home/.agents/skills/other.md" || fail "Keep unrelated files"

conflict="$TMP_DIR/conflict"
mkdir -p "$conflict/.agents/skills/terminal-browser"
printf 'custom skill\n' > "$conflict/.agents/skills/terminal-browser/SKILL.md"
stow -d "$ROOT_DIR" -t "$conflict" agents
if HOME="$conflict" bash "$ROOT_DIR/scripts/link-terminal-browser-skill.sh" > "$TMP_DIR/conflict.log" 2>&1; then
	fail "Report a custom skill that blocks the shared link"
fi
grep -Fq "$conflict/.agents/skills/terminal-browser" "$TMP_DIR/conflict.log" || fail "Name the conflict"
grep -Fxq 'custom skill' "$conflict/.agents/skills/terminal-browser/SKILL.md" || fail "Keep the custom skill"

alias_home="$TMP_DIR/alias"
mkdir -p "$alias_home/.config/agents/skills" "$alias_home/.claude" "$alias_home/.config/opencode" "$TMP_DIR/vendor"
printf 'vendor skill\n' > "$TMP_DIR/vendor/SKILL.md"
ln -s "$TMP_DIR/vendor" "$alias_home/.config/agents/skills/terminal-browser"
ln -s ../.config/agents/skills "$alias_home/.claude/skills"
ln -s ../agents/skills "$alias_home/.config/opencode/skills"
if HOME="$alias_home" bash "$ROOT_DIR/scripts/link-terminal-browser-skill.sh" >/dev/null 2>&1; then
	fail "Do not accept a vendor skill as the canonical source"
fi
[[ ! -e "$alias_home/.agents" ]] || fail "Reject the wrong source before changing links"

folded="$TMP_DIR/folded"
mkdir -p "$folded"
ln -s "$TMP_DIR/vendor" "$folded/.claude"
stow -d "$ROOT_DIR" -t "$folded" agents
if HOME="$folded" bash "$ROOT_DIR/scripts/link-terminal-browser-skill.sh" >/dev/null 2>&1; then
	fail "Do not write through a folded Claude directory"
fi
[[ ! -e "$TMP_DIR/vendor/skills" ]] || fail "Keep the folded target clean"

if command -v terminal-browser >/dev/null; then
	HOME="$fresh" terminal-browser ls >/dev/null
	marker="$fresh/.local/state/terminal-browser/setup-version"
	[[ -s "$marker" ]] || fail "The CLI must finish first-use setup"
	printf '0.0.0 /old/distribution\n' > "$marker"
	HOME="$fresh" terminal-browser ls >/dev/null
	if [[ ! -s "$marker" ]] || grep -Fxq '0.0.0 /old/distribution' "$marker"; then
		fail "The CLI must refresh the old marker"
	fi
	for path in .agents/skills .claude/skills; do
		[[ "$fresh/$path/terminal-browser/SKILL.md" -ef "$fresh/.config/agents/skills/terminal-browser/SKILL.md" ]] ||
			fail "$path must keep the canonical link after vendor setup"
	done
else
	echo 'SKIP: Terminal Browser CLI is not installed'
fi

echo 'PASS: fresh install, repeat install, Homebrew migration, custom skill protection, and source checks'
