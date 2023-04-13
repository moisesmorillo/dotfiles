#!/bin/bash

### Enable Extra Repositories ###
sudo dnf -y copr enable agriffis/neovim-night
sudo dnf -y copr enable lyatim/lazygit 
sudo dnf -y copr enable yorickpeterse/lua-language-server
sudo dnf -y install fedora-workstation-repositories
sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf -y install dnf-utils

### Update OS ###
sudo dnf update -y && sudo dnf upgrade -y

### Install Basic Packages ###
sudo dnf -y install htop wget curl unrar p7zip p7zip-plugins snapd libdvdread libdvdnav lsdvd flatpak --setopt=strict=0

### Config snapd ###
sudo ln -sf /var/lib/snapd/snap /snap

### Install Git ###
sudo dnf install -y git

### Install Zsh ###
sudo dnf install -y zsh
sudo chsh -s $(which zsh) $USER
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

### Install Zsh Plugins ###
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

### Kitty ###
sudo dnf install -y kitty
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
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip
unzip JetBrainsMono.zip -d ~/.fonts
rm JetBrainsMono.zip
fc-cache -fv

### Install Nvm ###
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
[ -s "$HOME/.nvm/nvm.sh" ] && \. "$HOME/.nvm/nvm.sh"
nvm install --lts && nvm alias default node

### Install Rbenv ###
sudo dnf install -y rbenv

### Install Go ###
sudo dnf install -y golang

### Install Java ###
sudo dnf install -y java-17-openjdk-headless.x86_64

### Install Rust ###
sudo dnf remove -y rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

### Install Neovim ###
sudo dnf install -y neovim python3-neovim

### Install Neovim Plugins ###
sudo dnf install -y fzf
sudo dnf install -y lua-language-server
sudo dnf install ripgrep
go install golang.org/x/tools/gopls@latest
rm -rf ~/.local/share/nvim/site/pack/packer ~/.config/nvim/plugin/packer_compiled.lua
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'


### Clone and set dotfiles ###
rm -rf ~/.config/nvim ~/.config/kitty
ln -sf ~/projects/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/projects/dotfiles/.zshrc ~/.zshrc
ln -sf ~/projects/dotfiles/.config/kitty ~/.config/kitty
ln -sf ~/projects/dotfiles/.config/nvim ~/.config/nvim

### Install Btop ###
sudo dnf install -y btop

### Install Exa ###
sudo dnf install -y exa

### Install Bat ###
sudo dnf install -y bat

### Install Yq ###
sudo snap install yq

### Install Lazygit ###
sudo dnf install lazygit

### Install Tmux ###
sudo dnf install -y tmux

### Clean System ###
sudo dnf clean packages -y && sudo dnf autoremove -y && sudo dnf clean all -y
