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

### Update Brew ###
brew update && brew upgrade

### Install from Brewfile
brew bundle install --file=./brew/Brewfile

### Update docker config file
. ./scripts/update-docker-config.sh

### Create default colima machine
colima start --cpu 2 --memory 2 --disk 50

### Install mise plugins (tool version manager)
mise install node@lts
mise install golang@latest
mise install python@3.11

### Install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

### Install Java ###
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk

### Install Tpm ###
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

### Customize bat ###
mkdir -p "$(bat --config-dir)/themes"
# shellcheck disable=SC2164
cd "$(bat --config-dir)/themes"
git clone git@github.com:enkia/enki-theme.git
bat cache --build

### Set defaults mac os
chmod +x "${SCRIPT_DIR}/macos-settings.sh"
#shellcheck disable=SC1091
source "${SCRIPT_DIR}/macos-settings.sh"

### Customize Eza ###
mkdir -p ~/.config/eza
curl -L https://github.com/folke/tokyonight.nvim/raw/main/extras/eza/tokyonight.yml -o ~/.config/eza/theme.yml

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
	rm -rf $pattern 2>/dev/null
done

# Change to root directory before running stow
cd "$ROOT_DIR" || exit
# shellcheck disable=SC2035
/opt/homebrew/bin/stow -R -t "$HOME" */
