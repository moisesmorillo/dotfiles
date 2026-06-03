#!/bin/bash
# shellcheck disable=SC1090,SC1091
[ -z "$ZPROF" ] || zmodload zsh/zprof
export PATH="/usr/local/bin:$HOME/.local/bin:$PATH"

if type mise &>/dev/null; then
	eval "$(mise activate zsh)"
fi

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
# fzf shell integration (Ctrl-T files, Alt-c cd, Ctrl-R history).
# fzf >=0.48 ships bindings via `fzf --zsh` instead of the old ~/.fzf.zsh file.
if command -v fzf &>/dev/null; then
	source <(fzf --zsh)
fi
[ -f ~/.zsh_utils ] && source ~/.zsh_utils
[ -f ~/.zsh_bindkeys ] && source ~/.zsh_bindkeys
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases
[ -f ~/.zsh_options ] && source ~/.zsh_options

export EDITOR="nvim"
# shellcheck disable=SC2155
export GPG_TTY="$(tty)"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
# Ctrl-T / Ctrl-F (files) and Ctrl-P (fzf-cd-widget -> directories).
# Without FZF_ALT_C_COMMAND, the cd widget would fall back to the files command.
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
# rose-pine color theme for fzf
# bg:-1 and gutter:-1 use the terminal's own background -> transparent, so fzf
# blends with Ghostty instead of painting a solid rose-pine dark panel.
# bg+ keeps a faint tint so the selected line stays visible.
export FZF_DEFAULT_OPTS="
  --ignore-case
  --color=fg:#908caa,bg:-1,hl:#ebbcba
	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
	--color=border:#403d52,header:#31748f,gutter:-1
	--color=spinner:#f6c177,info:#9ccfd8
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa
"
# Mason binaries
export PATH="$PATH:$HOME/.local/share/nvim/mason/bin"
export BAT_THEME="rose-pine"
# Set bat as default pager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# Clangd libc++ path
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
# Eza config dir
export EZA_CONFIG_DIR="$HOME/.config/eza"
# Lazygit config file
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"
# Yarn binaries
export PATH="$PATH:$HOME/.yarn/bin"
# Added by Antigravity
export PATH="$PATH:$HOME/.antigravity/antigravity/bin"
# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"
export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins/"

if type starship &>/dev/null; then
	eval "$(starship init zsh)"
fi

if [[ -f ~/.cargo/env ]]; then
	source ~/.cargo/env
fi

if [[ ! -f /tmp/.fastfetch_executed_$USER ]]; then
	fastfetch
	touch /tmp/.fastfetch_executed_$USER
fi

[ -z "$ZPROF" ] || zprof >~/.zprof.log

# Force thin vertical blinking bar cursor in each new shell
echo -ne '\033[5 q\033[?12;25h'
