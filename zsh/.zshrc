[ -z "$ZPROF" ] || zmodload zsh/zprof

autoload -Uz compinit
() {
  if [[ $# -gt 0 ]]; then
    compinit
  else
    compinit -C
  fi
} ${ZDOTDIR:-$HOME}/.zcompdump(N.mh+24)


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_THEME="powerlevel10k/powerlevel10k"

# Load homebrew bin paths
if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export PATH="/usr/local/bin:$HOME/.local/bin:$PATH"
export EDITOR="nvim"
export GPG_TTY="$(tty)"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

alias nv="nvim"
alias ff="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias ls="exa --icons"
alias ll="exa --icons --long --all --header"
alias tree="exa --icons --tree"
alias lzg="CONFIG_DIR='$HOME/.config/lazygit' lazygit"
alias lzd="lazydocker"
alias ssh='TERM=xterm-256color ssh'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
  bindkey "^[[1;3C" forward-word
  bindkey "^[[1;3D" backward-word
fi

# Path customization
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Ruby customization
if type rbenv &> /dev/null; then
  export PATH="$PATH:$HOME/.rbenv/bin"

  rbenv () {
    unset -f rbenv > /dev/null 2>&1
    eval "$(rbenv init - -zsh)"
    rbenv "$@"
  }
fi

# Python customization
if type pyenv &> /dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"

  pyenv () {
    unset -f pyenv > /dev/null 2>&1
    eval "$(pyenv init -)"
    pyenv "$@"
  }
fi

# Go customization
if type rbenv &> /dev/null; then
  export GOENV_ROOT="$HOME/.goenv"
  export GOENV_SHELL=zsh
  export PATH="$PATH:$GOENV_ROOT/shims:$GOENV_ROOT/bin:$GOROOT/bin:$GOPATH/bin"

  goenv () {
    unset -f goenv > /dev/null 2>&1
    eval "$(goenv init -)"
    goenv "$@"
  }
fi

# Mason binaries
export PATH="$PATH:$HOME/.local/share/nvim/mason/bin"

# Macro to kill the docker desktop app and the VM (excluding vmnetd -> it's a service)
kdo() {
  ps ax| grep -i docker| egrep -iv 'grep|com.docker.vmnetd'| awk '{print $1}'| xargs kill
}

if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi

zsh_time() {
  repeat 10 {time zsh -i -c exit}
}

fu() {
  OS=$(uname -s)

  echo "*** Updating OS packages and zsh plugins ***"

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

	cd ~/projects/dotfiles/ && git pull origin main && cd -

  zprezto-update
}

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

[ -z "$ZPROF" ] || zprof > ~/.zprof.log 
