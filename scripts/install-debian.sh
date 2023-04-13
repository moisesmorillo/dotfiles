#!/bin/bash

### Enable Extra Repositories ###
sudo add-apt-repository restricted
sudo add-apt-repository universe
sudo apt-get update


### Update OS ###
sudo apt update -y && sudo apt upgrade -y && sudo apt full-upgrade -y

### Install Basic Packages
sudo apt-get install unrar p7zip p7zip-plugins snapd libdvdread6 libdvdnav4 lsdvd libdvd-pkg flatpak build-essential libcurl4-openssl-dev libssl-dev htop wget curl

### Install Git ###
sudo apt-get install -y git

### Install Zsh ###
sudo apt-get install -y zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

### Install Zsh Plugins ###
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

### Install Kitty Term ###
sudo apt-get install -y kitty
# Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
# your system-wide PATH)
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
# Place the kitty.desktop file somewhere it can be found by the OS
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
# If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
# Update the paths to the kitty and its icon in the kitty.desktop file(s)
sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop

### Install Jetbrains Font ###
sh -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

### Install Neovim ###
sudo apt-get install -y neovim python3-neovim

### Install Neovim Plugins ###
sudo apt-get install -y fzf
# TODO install lua-language-server
sudo apt-get install ripgrep

### Clone and set dotfiles ###
rm -rf ~/.config/nvim ~/.config/kitty
ln -sf ~/projects/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/projects/dotfiles/.zshrc ~/.zshrc
ln -sf ~/projects/dotfiles/.config/kitty ~/.config/kitty
ln -sf ~/projects/dotfiles/.config/nvim ~/.config/nvim

### Install Btop ###
sudo snap install btop

### Install Exa ###
sudo apt-get install -y exa

### Install Bat ###
sudo apt-get install -y bat

### Install Yq ###
sudo snap install yq

### Install Lazygit ###
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

### Install Tmux ###
sudo apt-get install -y tmux

### Install Nvm ###
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
[ -s "$HOME/.nvm/nvm.sh" ] && \. "$HOME/.nvm/nvm.sh"
nvm install --lts && nvm alias default node

### Install Rbenv ###
sudo apt-get install -y rbenv
