#!/bin/bash
#
# Browser
#

if [[ -z "$BROWSER" && "$OSTYPE" == darwin* ]]; then
	export BROWSER="open"
fi

#
# Editors
#

if [[ -z "$VISUAL" ]]; then
	export VISUAL="nvim"
fi
if [[ -z "$PAGER" ]]; then
	export PAGER="less"
fi

#
# Language
#

if [[ -z "$LANG" ]]; then
	export LANG="en_US.UTF-8"
fi

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
