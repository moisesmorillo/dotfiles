#!/bin/bash
# Dotfiles install for a devcontainer / Linux dev sandbox (e.g. the Saptiva workspace
# meta-repo, driven by the `devcontainer` CLI — no VS Code). Unlike install-mac.sh this
# does NOT install brew, colima, or apply macOS defaults. It assumes the host/feature
# already provides zsh + a toolchain manager (mise) and just lays down the config via
# stow, then lets mise install whatever the repo's mise config declares.
#
# Non-interactive: the environment is selected by DOTFILES_ENV (default: work), since a
# devcontainer postCreate has no TTY to prompt on.

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

### Remove paths that would conflict with stow (same set install-mac.sh clears) ###
for pattern in \
	~/.config/nvim \
	~/.config/tmux \
	~/.local/share/nvim \
	~/.config/lazygit \
	~/.tmux \
	~/.hammerspoon \
	~/.config/pi; do
	rm -rf "$pattern" 2>/dev/null || true
done

### Stow every package dir into $HOME ###
cd "$ROOT_DIR" || exit 1
# shellcheck disable=SC2035
stow -R -t "$HOME" */

### Install tmux plugin manager (config references it) ###
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	git clone --quiet https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" || true
fi

### Let mise install whatever the stowed mise config declares, then warm bat cache ###
mise install || true
mise exec -- bat cache --build 2>/dev/null || true

echo "dotfiles(devcontainer): done"
