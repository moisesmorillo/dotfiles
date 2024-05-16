#!/bin/bash
# shellcheck disable=SC1090
[ -z "$ZPROF" ] || zmodload zsh/zprof

# Load homebrew bin paths
if [ -f /opt/homebrew/bin/brew ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

autoload -U compinit
compinit -C

# Load custom files plugins and personal custom files
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
export BAT_THEME="Catppuccin Mocha"
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
	export PATH="$PATH:$GOENV_ROOT/shims:$GOENV_ROOT/bin"

	goenv() {
		unset -f goenv >/dev/null 2>&1
		eval "$(goenv init -)"
		export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"
		export GOBIN="$GOPATH/bin"
		goenv "$@"
	}
fi

# Rusts customization
[ -f ~/.cargo/env ] && source ~/.cargo/env

if type starship &>/dev/null; then
	eval "$(starship init zsh)"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
	print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
	command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
	command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" &&
		print -P "%F{33} %F{34}Installation successful.%f%b" ||
		print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
# shellcheck disable=SC2154
if [[ -n "${_comps+z}" ]]; then
	_comps[zinit]=_zinit
fi
# Load zinit plugins
[ -f ~/.zinit_plugins ] && source ~/.zinit_plugins
### End of Zinit's installer chunk

[ -z "$ZPROF" ] || zprof >~/.zprof.log
