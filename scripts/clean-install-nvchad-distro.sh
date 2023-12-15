#!/bin/bash

stow -D nvim -t $HOME
rm -rf ~/.config/nvim/ ~/.local/share/nvim/ ~/.local/state/nvim/ ~/.cache/nvim/
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
stow -R -t $HOME nvim
