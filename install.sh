source ./scripts/utils.sh

os_name=$(get_os_name)

if [[ "$os_name" == "debian" || "$os_name" == "ubuntu" ]]; then
    # Install Debian/Ubuntu Packages
    source ./scripts/install-debian.sh
elif [[ "$os_name" == "fedora" ]]; then
    # Install Fedora Packages
    source ./scripts/install-fedora.sh
elif [[ "$os_name" == "macos" ]]; then
    # Install Mac Packages
    source ./scripts/install-mac.sh
fi


# # Clean packer
# rm -rf ~/.local/share/nvim/site/pack/packer
# rm ~/.config/nvim/plugin/packer_compiled.lua

# git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'



