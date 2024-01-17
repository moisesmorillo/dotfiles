#!/bin/bash

stow -D nvim -t "$HOME"
rm -rf ~/.config/nvim/ ~/.local/share/nvim/ ~/.local/state/nvim/ ~/.cache/nvim/
stow -R -t "$HOME" nvim
