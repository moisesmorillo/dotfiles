#!/bin/bash

export NONINTERACTIVE=1

### Install Brew ###
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

### Update Brew
brew update && brew upgrade

### Install Git ###
brew install git

### Install Zsh ###
brew install zsh
sudo chsh -s $(which zsh) $USER
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

### Install Zsh Plugins ###
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

### Install Alacritty ###
brew install --cask alacritty
curl https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info -o alacritty.info
sudo tic -xe alacritty,alacritty-direct alacritty.info
rm alacritty.info
### Install Jetbrains Font ###
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font

### Install Nvm ###
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
[ -s "$HOME/.nvm/nvm.sh" ] && \. "$HOME/.nvm/nvm.sh"
nvm install --lts && nvm alias default node
npm install -g yarn
yarn globall add @githubnext/github-copilot-cli

### Install Rbenv ###
brew install rbenv ruby-build

### Install Go ###
brew install go

### Install Java ###
brew install openjdk@17
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk

### Install Rust ###
brew uninstall rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

### Install Neovim ###
brew install neovim

### Install Neovim Plugins ###
brew install fzf
$(brew --prefix)/opt/fzf/install --all --key-bindings --completion
brew install ripgrep
go install golang.org/x/tools/gopls@latest

### Clone and set dotfiles ###
ln -sf ~/projects/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/projects/dotfiles/.zshrc ~/.zshrc
ln -sf ~/projects/dotfiles/.config/alacritty ~/.config/alacritty
ln -sf ~/projects/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/projects/dotfiles/.config/tmux ~/.config/tmux

### Install Btop ###
brew install btop

### Install Exa ###
brew install exa

### Install Bat ###
brew install bat

### Install Yq ###
brew install yq

### Install Lazygit ###
brew install jesseduffield/lazygit/lazygit
brew install lazygit

### Install Tmux ###
brew install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

### Install 1Password CLI
brew install --cask 1password/tap/1password-cli

unset NONINTERACTIVE

