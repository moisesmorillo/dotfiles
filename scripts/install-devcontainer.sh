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

# Two sources of "don't stow this":
#   1. OUR_SKIP — packages that are OUR repo's concern: macOS/host-only configs that
#      mean nothing on Linux, plus non-package dirs. These belong here.
#   2. $DOTFILES_SKIP_PACKAGES — injected by the HOST ENVIRONMENT (e.g. a devcontainer
#      meta-repo) to name packages IT already manages (its shell/agent/toolchain config).
#      That knowledge lives in the environment, not hardcoded here, so this repo stays
#      generic across sandboxes. We merge both lists.
# NOTE: `zsh` is intentionally NOT in OUR_SKIP — we replace the generated ~/.zshrc with
# ours (self-contained: mise, zinit, beam cursor, zoxide). Conflicts are backed up below.
OUR_SKIP="brew aerospace borders hammerspoon karabiner scripts plans screenshots"
SKIP="$OUR_SKIP ${DOTFILES_SKIP_PACKAGES:-}"

# The feature pre-generates shell files in $HOME; stow would abort on them. Since we own
# the shell now, back up each conflicting file once (.pre-dotfiles suffix) and remove it
# so stow can lay down our version. Derive the file list FROM the zsh package itself
# (top-level entries it ships) instead of hardcoding names — add a file to the package
# and this picks it up automatically.
if [ -d "$ROOT_DIR/zsh" ]; then
	for src in "$ROOT_DIR"/zsh/.[!.]*; do
		[ -e "$src" ] || continue
		t="$HOME/$(basename "$src")"
		# Only back up a real file/dir that isn't already our symlink.
		if [ -e "$t" ] && [ ! -L "$t" ]; then
			[ -e "$t.pre-dotfiles" ] || cp -a "$t" "$t.pre-dotfiles"
			rm -rf "$t"
		fi
	done
fi

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
rm -f /tmp/stow-*.err 2>/dev/null || true

### Merge our mise toolchain via conf.d (NOT by stowing config.toml) ###
# The `mise` package is in the denylist because the sandbox/feature owns
# ~/.config/mise/config.toml. But our config declares all the CLI tools the aliases
# need (eza, bat, fd, fzf, yazi, …). mise merges every ~/.config/mise/conf.d/*.toml
# WITH the feature config — same mechanism the workspace itself uses — so symlink ours
# in there to get our tools installed without clobbering the team toolchain. Resilient:
# only if our config actually exists in the repo.
MISE_CONFIG="$ROOT_DIR/mise/.config/mise/config.toml"
if [ -f "$MISE_CONFIG" ]; then
	mkdir -p "$HOME/.config/mise/conf.d"
	ln -sf "$MISE_CONFIG" "$HOME/.config/mise/conf.d/dotfiles.toml"
	echo "dotfiles(devcontainer): linked mise config -> conf.d/dotfiles.toml"
fi

### Install tmux plugin manager (config references it) ###
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	git clone --quiet https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" || true
fi

### Install everything the merged mise config now declares, then warm bat cache ###
# mise installs in parallel (--jobs), so a tool with no build for this platform (e.g.
# resvg/colima on linux/arm64) fails on its own WITHOUT blocking the rest — but it still
# makes `mise install` exit non-zero. We swallow that (|| true) and print a clear note so
# a red "mise ERROR" doesn't read as a total failure. The tools your aliases need install
# fine; the unsupported ones are simply skipped.
if ! mise install; then
	echo "dotfiles(devcontainer): note — some tools have no build for this platform" \
	     "(e.g. resvg/colima/lima on linux/arm64) and were skipped; everything else installed."
fi
mise exec -- bat cache --build 2>/dev/null || true

echo "dotfiles(devcontainer): done"
