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
