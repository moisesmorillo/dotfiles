#!/bin/bash

stow -D nvim -t $HOME -v 5
rm -rf ~/.config/nvim/ ~/.local/share/nvim/ ~/.local/state/nvim/ ~/.cache/nvim/
stow -R -t $HOME nvim -v 5
