#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="$HOME/.config/agents/skills/terminal-browser"
repo_skill="$root_dir/agents/.config/agents/skills/terminal-browser/SKILL.md"
claude_home="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
if [[ ! "$source_dir/SKILL.md" -ef "$repo_skill" ]]; then
	printf 'Stow the agents package from this repository before linking %s.\n' "$source_dir" >&2
	exit 1
fi
if [[ -L "$claude_home" && ! "$claude_home/skills/terminal-browser" -ef "$source_dir" ]]; then
	if [[ "$claude_home" != "$HOME/.claude" || ! "$claude_home" -ef "$root_dir/claude/.claude" ]]; then
		printf 'Use a real Claude config directory before linking skills: %s\n' "$claude_home" >&2
		exit 1
	fi
	# Keep Stow links to the existing contents, but make ~/.claude a real directory.
	stow --no-folding -R -d "$root_dir" -t "$HOME" claude
	if [[ -L "$claude_home" ]]; then
		printf 'Stow did not unfold the Claude config directory: %s\n' "$claude_home" >&2
		exit 1
	fi
fi

is_vendor_link() {
	[[ -L "$1" ]] || return 1
	case "$(readlink "$1")" in
	/*/Caskroom/terminal-browser/*/terminal-browser/skills/*/terminal-browser) return 0 ;;
	*) return 1 ;;
	esac
}

# Check both targets before changing either link.
for skills_dir in "$HOME/.agents/skills" "$claude_home/skills"; do
	entry="$skills_dir/terminal-browser"
	if [[ "$entry" -ef "$source_dir" ]] || is_vendor_link "$entry"; then
		continue
	fi
	if [[ -e "$entry" || -L "$entry" ]]; then
		printf 'Keep custom Terminal Browser skill at %s. Move it before retrying.\n' "$entry" >&2
		exit 1
	fi
done

# The CLI reads this choice on first use and after a version change.
state_home="${XDG_STATE_HOME:-}"
if [[ "$state_home" != /* ]]; then
	state_home="$HOME/.local/state"
fi
state_dir="$state_home/terminal-browser"
mkdir -p "$state_dir"
printf 'no\n' > "$state_dir/skills-choice"
# This release records only the Terminal Browser skill in this receipt.
rm -f "$state_dir/skills.links"

for skills_dir in "$HOME/.agents/skills" "$claude_home/skills"; do
	entry="$skills_dir/terminal-browser"
	[[ "$entry" -ef "$source_dir" ]] && continue
	mkdir -p "$skills_dir"
	if is_vendor_link "$entry"; then
		rm "$entry"
	fi
	ln -s "$source_dir" "$entry"
done

# These agents also read ~/.agents/skills. Keep custom entries in their native paths.
for skills_dir in "${CODEX_HOME:-$HOME/.codex}/skills" "$HOME/.gemini/skills" \
	"${XDG_CONFIG_HOME:-$HOME/.config}/opencode/skills" "${XDG_CONFIG_HOME:-$HOME/.config}/amp/skills"; do
	entry="$skills_dir/terminal-browser"
	if is_vendor_link "$entry"; then
		rm "$entry"
	fi
done
