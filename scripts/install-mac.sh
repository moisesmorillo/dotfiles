#!/bin/bash

### Install Brew ###
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

### Update Brew
brew update && brew upgrade

### Enable Brew Taps ###
brew tap homebrew/cask-fonts

### Install All Brew Formulae ###
xargs brew install <./brew-formulae.txt

### Install All Brew Casks ###
xargs brew install --cask <./brew-cask.txt

### Install Oh My Zsh ###
rm -rf ~/.oh-my-zsh
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o install_ohmyzsh.sh

# Disable oh my zsh reloading after installing
awk '!/exec zsh -l/ { print } /exec zsh -l/ { print "# " $0 }' install_ohmyzsh.sh >temp_install.sh && mv temp_install.sh install_ohmyzsh.sh
sh install_ohmyzsh.sh
rm install_ohmyzsh.sh

### Install Zsh Plugins ###
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

### Install Alacritty ###
curl https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info -o alacritty.info
sudo tic -xe alacritty,alacritty-direct alacritty.info
rm alacritty.info

### Install Nvm ###
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
[ -s "$HOME/.nvm/nvm.sh" ] && \. "$HOME/.nvm/nvm.sh"
nvm install --lts && nvm alias default node
npm install -g yarn
yarn global add @githubnext/github-copilot-cli

### Install Go ###
goenv install 1.21.1
goenv global 1.21.1
brew install golangci-lint mockery

### Install Java ###
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk

### Install Rust ###
brew uninstall rust | true
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

### Install FzF completions ###
$(brew --prefix)/opt/fzf/install --all --key-bindings --completion

### Clone and set dotfiles ###
rm -rf ~/.config/alacritty ~/.config/nvim ~/.config/tmux ~/.local/share/nvim ~/.config/lazygit ~/.zshrc* ~/.p10k.zsh
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
stow -R -t $HOME */

### Install Tpm ###
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

### Set defaults mac os
chmod +x ./install-mac.sh
. ./install-mac.sh
