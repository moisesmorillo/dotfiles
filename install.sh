#!/bin/bash

# Clean packer
rm -rf ~/.local/share/nvim/site/pack/packer
rm ~/.config/nvim/plugin/packer_compiled.lua

git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Dectect OS
if [[ "$(uname)" == "Darwin" ]]; then
  echo "MacOS"
elif [[ "$(uname)" == "Linux" ]]; then
  # Detect supported Linux version
  if [ -r /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
      echo "Debian or Ubuntu: $ID"
    elif [[ "$ID" == "fedora" ]]; then
      echo "Fedora"
    else
      echo "Unsupported Linux Version, exiting now..."
      exit 1
    fi
 fi
else
  echo "Unsupported OS"
  exit 1
fi

