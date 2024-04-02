#!/bin/bash
[ -z "$ZPROF" ] || zmodload zsh/zprof

# Load homebrew bin paths
if [ -f /opt/homebrew/bin/brew ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# shellcheck disable=SC1090
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# shellcheck disable=SC1090
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# shellcheck disable=SC1090
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="/usr/local/bin:$HOME/.local/bin:$PATH"
export EDITOR="nvim"
# shellcheck disable=SC2155
export GPG_TTY="$(tty)"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

alias nv="nvim"
alias ff="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias ls="exa --icons"
alias ll="exa --icons --long --all --header"
alias tree="exa --icons --tree"
alias lzg="lazygit -ucd ~/.config/lazygit"
alias lzd="lazydocker"
alias ssh='TERM=xterm-256color ssh'

# Load Linux OS customization
if [[ $(uname -s) == "Linux" ]]; then
	# alias to replace cat for bat
	export PATH="/usr/local/sbin:/snap/bin:/usr/local/go/bin:/sbin:/usr/sbin:$PATH"
	alias cat="batcat"
fi

# Load Mac OS customization
if [[ $(uname -s) == "Darwin" ]]; then
	# alias to replace cat for bat
	alias cat="bat"

	# reset zsh bindings
	bindkey -d
	# allow option + arrow keys to move by word
	bindkey "^[[1;3C" forward-word
	bindkey "^[[1;3D" backward-word

	# allow ctrl-r to search the history
	bindkey '^r' fzf-history-widget

	# allow ctrl-a and ctrl-e to move to beginning/end of line
	bindkey '^a' beginning-of-line
	bindkey '^e' end-of-line
fi

# Path customization

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

# Mason binaries
export PATH="$PATH:$HOME/.local/share/nvim/mason/bin"

# Macro to kill the docker desktop app and the VM (excluding vmnetd -> it's a service)
kdo() {
	pgrep -fi orbstack | xargs kill
}

if [ -f "$HOME/.cargo/env" ]; then
	# shellcheck disable=SC1091
	source "$HOME/.cargo/env"
fi

zsh_time() {
	repeat 10 time zsh -i -c exit
}

fu() {
	OS=$(uname -s)

	echo "*** Updating OS packages***"

	if [[ "$OS" == "Darwin" ]]; then
		brew update
		brew upgrade
	fi

	if [[ "$OS" == "Linux" ]]; then
		sudo apt update -y
		sudo apt full-upgrade -y
		sudo apt autoremove -y
		sudo apt autoclean -y
	fi

	echo "*** Updating dotfiles ***"
	cd ~/projects/dotfiles/ && git pull origin main && cd - || exit

	echo "*** Updating LazyVim core and plugins ***"
	nvim --headless "+Lazy! sync" +qa
}

if type starship &>/dev/null; then
	eval "$(starship init zsh)"
fi

[ -z "$ZPROF" ] || zprof >~/.zprof.log
