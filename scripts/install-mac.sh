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

### Remove alacrity terminfo ###
sudo rm -rf ~/.terminfo

### Enable Brew Taps ###
brew tap homebrew/cask-fonts

### Install All Brew Formulae ###
xargs brew install --force <./scripts/brew-formulae.txt

### Install All Brew Casks ###
xargs brew install --cask --force <./scripts/brew-cask.txt

### Install Alacritty ###
curl https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info -o alacritty.info
sudo tic -xe alacritty,alacritty-direct alacritty.info
rm alacritty.info

### Install Volta (Node Package Manager) ###
curl https://get.volta.sh | bash
omz reload
volta install node yarn # To install LTS Version

### Install Go ###
goenv install latest
goenv global "$(goenv versions --bare | sort -V | tail -n 2)"
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$(go env GOPATH)/bin latest"

### Install Java ###
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk

### Install Rust ###
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

### Install FzF completions ###
$(brew --prefix)/opt/fzf/install --all --key-bindings --completion

### Install Tpm ###
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

### Install Prezto for ZSH ###
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

### Set defaults mac os
chmod +x ./scripts/macos-settings.sh
. ./scripts/macos-settings.sh

### Clone and set dotfiles ###
rm -rf ~/.config/alacritty ~/.config/nvim ~/.config/tmux ~/.local/share/nvim ~/.config/lazygit ~/.zshrc* ~/.p10k.zsh ~/.tmux ~/.zprofile* ~/.zsh_history* ~/.zsh_sessions/ ~/.zshrc ~/.zshenv
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
stow -R -t $HOME */
