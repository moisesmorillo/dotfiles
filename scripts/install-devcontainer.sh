#!/bin/bash
# Dotfiles install for a devcontainer / Linux dev sandbox (e.g. the Saptiva workspace
# meta-repo, driven by the `devcontainer` CLI — no VS Code). Unlike install-mac.sh this
# does NOT install brew, colima, or apply macOS defaults. It lays down config via stow
# (skipping packages the sandbox already owns), then lets mise install the toolchain.
#
# Non-interactive: environment selected by DOTFILES_ENV (default work) — a devcontainer
# postCreate has no TTY to prompt on.
#
# WHY package-by-package with a denylist instead of `stow */`: the sandbox/feature
# already manages ~/.zshrc, ~/.claude/settings.json, mise config, and the opencode/
# claude AGENTS symlinks. `stow */` aborts the WHOLE run on the first such conflict.
# Stowing one package at a time means a conflict only skips THAT package, and we never
# touch the files the workspace depends on. Override the skip list with
# DOTFILES_SKIP_PACKAGES, or restrict to an explicit set with DOTFILES_PACKAGES.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

DOTFILES_ENV="${DOTFILES_ENV:-work}"
echo "dotfiles(devcontainer): environment = $DOTFILES_ENV"

### Ensure stow is available (mise doesn't ship it; apt is the reliable path) ###
if ! command -v stow >/dev/null 2>&1; then
	echo "dotfiles(devcontainer): installing GNU Stow"
	sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq
	sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq stow >/dev/null
fi

### Ensure mise is available (the workspace provides it, but be self-contained) ###
if ! command -v mise >/dev/null 2>&1; then
	curl -fsSL https://mise.run | sh
	export PATH="$HOME/.local/bin:$PATH"
	eval "$(mise activate bash)"
fi

# Packages the SANDBOX/FEATURE owns (stowing them breaks team config) + host/macOS-only
# packages that have no meaning on Linux + non-package dirs. Space-separated.
DEFAULT_SKIP="claude mise zsh opencode gemini agents \
              brew aerospace borders hammerspoon karabiner \
              scripts plans screenshots"
SKIP="${DOTFILES_SKIP_PACKAGES:-$DEFAULT_SKIP}"

# Build the package list: explicit DOTFILES_PACKAGES wins; else every top-level dir
# minus the skip list.
if [ -n "${DOTFILES_PACKAGES:-}" ]; then
	candidates="$DOTFILES_PACKAGES"
else
	candidates=""
	for d in "$ROOT_DIR"/*/; do
		candidates="$candidates $(basename "$d")"
	done
fi

cd "$ROOT_DIR" || exit 1

stowed=""
skipped=""
for pkg in $candidates; do
	[ -d "$ROOT_DIR/$pkg" ] || continue
	case " $SKIP " in *" $pkg "*) skipped="$skipped $pkg"; continue ;; esac
	# Stow this one package; on conflict, skip it (don't abort the whole run).
	if stow -R -t "$HOME" "$pkg" 2>"/tmp/stow-$pkg.err"; then
		stowed="$stowed $pkg"
	else
		skipped="$skipped $pkg(conflict)"
		echo "dotfiles(devcontainer): skip '$pkg' (stow conflict — see /tmp/stow-$pkg.err)"
	fi
done

echo "dotfiles(devcontainer): stowed:$stowed"
echo "dotfiles(devcontainer): skipped:$skipped"

### Install tmux plugin manager (config references it) ###
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	git clone --quiet https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" || true
fi

### Let mise install whatever the stowed mise config declares, then warm bat cache ###
mise install || true
mise exec -- bat cache --build 2>/dev/null || true

echo "dotfiles(devcontainer): done"
