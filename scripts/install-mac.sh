#!/bin/bash

### Install Brew ###
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

### Update Brew
brew update && brew upgrade

### Install Git ###
brew install git

### Gpg for commit signing
brew install gpg2 gnupg pinentry-mac

### Install Zsh ###
rm -rf ~/.oh-my-zsh
brew install zsh
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o install_ohmyzsh.sh
# disable zsh reloading after installing
awk '!/exec zsh -l/ { print } /exec zsh -l/ { print "# " $0 }' install_ohmyzsh.sh >temp_install.sh && mv temp_install.sh install_ohmyzsh.sh
sh install_ohmyzsh.sh
rm install_ohmyzsh.sh

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

### Install PyEnv ###
brew install pyenv

### Install Nvm ###
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
[ -s "$HOME/.nvm/nvm.sh" ] && \. "$HOME/.nvm/nvm.sh"
nvm install --lts && nvm alias default node
npm install -g yarn
yarn global add @githubnext/github-copilot-cli

### Install Rbenv ###
brew install rbenv ruby-build

### Install Go ###
brew install goenv
goenv install 1.21.0
goenv global 1.21.0

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
brew install fd

#### Install Stackoverflow cmd ###
brew install so

### Clone and set dotfiles ###
rm -rf ~/.config/alacritty ~/.config/nvim ~/.config/tmux ~/.local/share/nvim ~/.config/lazygit ~/.zshrc* ~/.p10k.zsh
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
stow -R -t $HOME */

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

### Install Lazydocker
brew install jesseduffield/lazydocker/lazydocker

### Install Tmux ###
brew install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

### Install 1Password CLI
brew install --cask 1password/tap/1password-cli

### Install Dozer (hide menu bar icons)
brew install --cask dozer

### Install Raycast (Alfred alternative)
brew install --cask raycast

### Set defaults mac os
chmod +x ./install-mac.sh
. ./install-mac.sh
