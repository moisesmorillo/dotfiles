#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

### Select environment ###
echo ""
echo "Select your dotfiles environment:"
echo "  1) personal — base + personal apps (default)"
echo "  2) work     — base + work apps"
echo "  3) all      — base + personal + work apps"
echo ""
read -rp "Enter choice [1]: " env_choice
case "$env_choice" in
2) DOTFILES_ENV="work" ;;
3) DOTFILES_ENV="all" ;;
*) DOTFILES_ENV="personal" ;;
esac
echo "Environment set to: $DOTFILES_ENV"
echo ""

### Uninstall Brew ###
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

### Install Brew ###
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

if ! command -v brew &>/dev/null; then
	echo "brew could not be found, exiting"
	exit 1
fi

### Install mise ###
curl https://mise.run | sh
eval "$(~/.local/bin/mise activate bash)"

### Update Brew ###
brew update && brew upgrade

### Install from Brewfiles (layered by environment)
echo "Installing Brewfile.base..."
if ! brew bundle install --file=./brew/Brewfile.base; then
	echo "brew bundle (base) failed, exiting"
	exit 1
fi

if [[ "$DOTFILES_ENV" == "personal" || "$DOTFILES_ENV" == "all" ]]; then
	echo "Installing Brewfile.personal..."
	if ! brew bundle install --file=./brew/Brewfile.personal; then
		echo "brew bundle (personal) failed, exiting"
		exit 1
	fi
fi

if [[ "$DOTFILES_ENV" == "work" || "$DOTFILES_ENV" == "all" ]]; then
	echo "Installing Brewfile.work..."
	if ! brew bundle install --file=./brew/Brewfile.work; then
		echo "brew bundle (work) failed, exiting"
		exit 1
	fi
fi

### Update docker config file
. ./scripts/update-docker-config.sh

### Install Tpm ###
rm -rf ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

### Set defaults mac os
chmod +x "${SCRIPT_DIR}/macos-settings.sh"
#shellcheck disable=SC1091
source "${SCRIPT_DIR}/macos-settings.sh"

### Clone and set dotfiles ###
for pattern in \
	~/.config/nvim \
	~/.config/tmux \
	~/.local/share/nvim \
	~/.config/lazygit \
	~/.zshrc* \
	~/.tmux \
	~/.zprofile* \
	~/.zsh_history* \
	~/.zsh_sessions/ \
	~/.zshrc \
	~/.zshenv \
	~/.hammerspoon \
	~/.config/pi \
	~/.config/herdr-app/settings.json \
	~/.config/herdr-app/themes/rose-pine.json \
	~/.config/herdr-app/layouts/main-auto.json \
	~/.config/herdr-app/mods/auto-tabs \
	~/.orbstack/vmconfig.json; do
	rm -rf "$pattern" 2>/dev/null
done

# ~/.orbstack holds runtime state (sockets, logs, ssh keys). Make sure it exists
# as a real directory so stow only links vmconfig.json instead of folding the
# whole directory into the repo.
mkdir -p "$HOME/.orbstack"

# ~/.config/herdr-app holds the app's runtime state (socket, telemetry, generated guides).
# Make sure it exists as a real directory, so stow only links settings.json and the theme
# and does not fold the whole directory into the repo. The app writes settings.json
# through the symlink (checked with herdr-app 0.1.12), so the link survives its saves.
# layouts/ and mods/ also hold the app's shipped files, and the app writes
# gpui-kit.d.ts and jsconfig.json into every mod folder. So mods/auto-tabs is a real
# directory too, and stow links only the mod's own files.
mkdir -p "$HOME/.config/herdr-app/themes" \
	"$HOME/.config/herdr-app/layouts" \
	"$HOME/.config/herdr-app/mods/auto-tabs"

# Keep Pi's writable state out of the repository before stowing its config.
"$ROOT_DIR/scripts/prepare-pi-home.sh"

# Change to root directory before running stow
cd "$ROOT_DIR" || exit
# shellcheck disable=SC2035
/opt/homebrew/bin/stow -R -t "$HOME" */

# Post commands
mise install
mise exec -- "$ROOT_DIR/scripts/apply-pi-settings.sh"
mise exec -- "$ROOT_DIR/scripts/sync-pi-packages.sh"
mise exec -- bat cache --build

### herdr-core (hc) for herdr-app ###
# The herdr-app cask does not include hc. hc has no brew formula and no GitHub releases,
# so mise cannot pin it. Upstream's installer checks the sha256 from the release
# manifest. A remote machine that runs its own hc needs the same version.
HC_VERSION="0.1.17"
if [ "$("$HOME/.local/bin/hc" --version 2>/dev/null | awk '{print $2}')" != "$HC_VERSION" ]; then
	curl -fsSL https://releases.herdr.dev/core/install.sh | HC_VERSION="$HC_VERSION" sh
fi
