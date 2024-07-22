#!/bin/bash

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

### Enable Brew Taps ###
brew tap homebrew/cask-fonts

### Enable Terrform Tap ###
brew tap hashicorp/tap

### Install All Brew Formulae ###
xargs brew install --force <./scripts/brew-formulae.txt

### Install All Brew Casks ###
xargs brew install --cask --force <./scripts/brew-cask.txt

### Install mise plugins (tool version manager)
mise install node@lts
mise install golang@latest
mise install rust@latest
mise install python@3.11

### Install Java ###
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk

### Install Tpm ###
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

### Customize bat ###
mkdir -p "$(bat --config-dir)/themes"
wget -P "$(bat --config-dir)/themes" https://raw.githubusercontent.com/enkia/enki-theme/master/scheme/Enki-Tokyo-Night.tmTheme
bat cache --build

### Set defaults mac os
chmod +x ./scripts/macos-settings.sh
. ./scripts/macos-settings.sh

### Clone and set dotfiles ###
rm -rf ~/.config/nvim ~/.config/tmux ~/.local/share/nvim ~/.config/lazygit ~/.zshrc* ~/.tmux ~/.zprofile* ~/.zsh_history* ~/.zsh_sessions/ ~/.zshrc ~/.zshenv
stow -R -t $HOME */
