#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
### Enable Extra Repositories ###
sudo add-apt-repository restricted
sudo add-apt-repository universe
sudo apt-get update

### Install Basic Packages
sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq unrar p7zip build-essential libcurl4-openssl-dev libssl-dev curl bat tmux git zsh ripgrep fzf neovim python3-neovim rvenv

### Configure Zsh ###
sudo chsh -s $(which zsh) $USER
curl -Lo- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash

### Install Zsh Plugins ###
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

### Install Jetbrains Font ###
curl -Lo- https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh | bash

### Install Nvm ###
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
[ -s "$HOME/.nvm/nvm.sh" ] && \. "$HOME/.nvm/nvm.sh"
nvm install --lts && nvm alias default node

### Install Neovim Plugins ###
if command -v go &> /dev/null; then
    go install golang.org/x/tools/gopls@latest
fi

### Clone and set dotfiles ###
rm -rf ~/.config/nvim ~/.config/kitty
ln -sf /workspaces/.codespaces/.persistedshare/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf /workspaces/.codespaces/.persistedshare/dotfiles/.zshrc ~/.zshrc
ln -sf /workspaces/.codespaces/.persistedshare/dotfiles/.config/kitty ~/.config/kitty
ln -sf /workspaces/.codespaces/.persistedshare/dotfiles/.config/nvim ~/.config/nvim

### Install Btop ###
curl -LO https://github.com/aristocratos/btop/releases/download/v1.2.13/btop-x86_64-linux-musl.tbz
tar -xvf btop-x86_64-linux-musl.tbz
sudo mv ./btop/bin/btop /usr/local/bin/btop
sudo chmod +x /usr/local/bin/btop
rm -rf btop-x86_64-linux-musl.tbz btop

### Install Exa ###
curl -LO https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip
unzip exa-linux-x86_64-v0.10.0.zip -d exa
sudo mv ./exa/bin/exa /usr/local/bin/exa
sudo chmod +x /usr/local/bin/exa
rm -rf exa-linux-x86_64-v0.10.0.zip exa

### Install Yq ###
sudo curl -L "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64" -o /usr/local/bin/yq
sudo chmod +x /usr/local/bin/yq

### Install Lazygit ###
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
