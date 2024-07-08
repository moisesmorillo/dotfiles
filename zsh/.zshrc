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
export PATH="$PATH:$HOME/.local/share/nvim/mason/bin"
export BAT_THEME="Enki-Tokyo-Night"
# Set bat as default pager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# Clangd libc++ path
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# Node customization
if type volta &>/dev/null; then
  export VOLTA_HOME="$HOME/.volta"
  export PATH="$PATH:$VOLTA_HOME/bin"

  volta() {
    unset -f volta >/dev/null 2>&1
    eval "$(volta completions zsh)"
    volta "$@"
  }
fi

# Ruby customization
if type rbenv &>/dev/null; then
  export PATH="$PATH:$HOME/.rbenv/bin"

  rbenv() {
    unset -f rbenv >/dev/null 2>&1
    eval "$(rbenv init - -zsh)"
    rbenv "$@"
  }
fi

# Python customization
if type pyenv &>/dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"

  pyenv() {
    unset -f pyenv >/dev/null 2>&1
    eval "$(pyenv init -)"
    pyenv "$@"
  }
fi

# Go customization
if type goenv &>/dev/null; then
  export GOENV_ROOT="$HOME/.goenv"
  export GOENV_SHELL=zsh
  export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"
  export PATH="$PATH:$GOENV_ROOT/shims:$GOENV_ROOT/bin"
  source "$(dirname "$(greadlink -f "$(whence -p goenv)")")/../completions/goenv.zsh"
  export GOBIN="$GOPATH/bin"

  goenv() {
    unset -f goenv >/dev/null 2>&1
    goenv "$@"
  }
fi

# Rusts customization
[ -f ~/.cargo/env ] && source ~/.cargo/env

if type starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

[ -z "$ZPROF" ] || zprof >~/.zprof.log
