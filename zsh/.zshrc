#!/bin/bash
# shellcheck disable=SC1090
[ -z "$ZPROF" ] || zmodload zsh/zprof

# Load homebrew bin paths
if [ -f /opt/homebrew/bin/brew ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

autoload -U compinit
compinit
[ -f ~/.zsh/fzf-tab/fzf-tab.plugin.zsh ] && source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh

# Load custom files plugins and personal custom files
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] &&
	source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f ~/.zsh_utils ] && source ~/.zsh_utils
[ -f ~/.zsh_bindkeys ] && source ~/.zsh_bindkeys
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

export PATH="/usr/local/bin:$HOME/.local/bin:$PATH"
export EDITOR="nvim"
# shellcheck disable=SC2155
export GPG_TTY="$(tty)"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export PATH="$PATH:$HOME/.local/share/nvim/mason/bin"

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

[ -z "$ZPROF" ] || zprof >~/.zprof.log
