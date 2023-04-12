#!/bin/bash

### Install Brew ###
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

### Update Brew
brew update && brew upgrade

### Install Git ###
brew install git

### Install Zsh ###
brew install zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

### Install Zsh Plugins ###
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

### Install Kitty ###
brew install --cask kitty

### Install Neovim ###
brew install neovim

### Clone and set dotfiles ###
ln -sf ~/projects/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/projects/dotfiles/.zshrc ~/.zshrc
ln -sf ~/projects/dotfiles/.config/kitty ~/.config/kitty
ln -sf ~/projects/dotfiles/.config/nvim ~/.config/nvim

### Install Fuzzy Finder ###
brew install fzf
$(brew --prefix)/opt/fzf/install --all --key-bindings --completion

### Install Btop ###
brew install btop

### Install Exa ###
brew install exa

### Install Bat ###
brew install bat

### Install Yq ###
brew install yq
