#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

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

### Install from Brewfile
brew bundle install --file=./brew/Brewfile

### Update docker config file
. ./scripts/update-docker-config.sh

### Create default colima machine
colima start --cpu 2 --memory 2 --disk 50

### Install Tpm ###
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
	~/.zshenv; do
	rm -rf "$pattern" 2>/dev/null
done

# Change to root directory before running stow
cd "$ROOT_DIR" || exit
# shellcheck disable=SC2035
/opt/homebrew/bin/stow -R -t "$HOME" */

# Post commands
mise install
bat cache --build
