#!/bin/bash
# shellcheck disable=SC1090,SC1091
[ -z "$ZPROF" ] || zmodload zsh/zprof

# Load homebrew bin paths
if [ -f /opt/homebrew/bin/brew ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Zinit autoinstaller
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
	echo "Installing Zinit..."
	mkdir -p "$(dirname "$ZINIT_HOME")"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Load zinit plugins
[ -f ~/.zinit_plugins ] && source ~/.zinit_plugins

autoload -U compinit && compinit -C
zinit cdreplay -q

# Load custom file plugins and personal custom files
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zsh_utils ] && source ~/.zsh_utils
[ -f ~/.zsh_bindkeys ] && source ~/.zsh_bindkeys
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases
[ -f ~/.zsh_options ] && source ~/.zsh_options

export PATH="/usr/local/bin:$HOME/.local/bin:$PATH"
export EDITOR="nvim"
# shellcheck disable=SC2155
export GPG_TTY="$(tty)"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="--ignore-case"
export PATH="$PATH:$HOME/.local/share/nvim/mason/bin"
export BAT_THEME="Enki-Tokyo-Night"
# Set bat as default pager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# Clangd libc++ path
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

if type starship &>/dev/null; then
	eval "$(starship init zsh)"
fi

if type mise &>/dev/null; then
	eval "$(mise activate zsh)"
fi

[ -z "$ZPROF" ] || zprof >~/.zprof.log
