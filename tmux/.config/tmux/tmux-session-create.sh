#!/bin/bash

# Set gum theme to match rose-pine
export GUM_INPUT_PROMPT_FOREGROUND="#908caa"
export GUM_INPUT_PROMPT_BACKGROUND="#191724"
export GUM_INPUT_CURSOR_FOREGROUND="#c4a7e7"
export GUM_INPUT_CURSOR_BACKGROUND="#191724"
export GUM_INPUT_PLACEHOLDER_BACKGROUND="#191724"
export GUM_INPUT_PLACEHOLDER_FOREGROUND="#6e6a86"
export GUM_INPUT_HEADER_BACKGROUND="#191724"

# Prompt user for session name using fzf with --print-query
session_name=$(
	gum \
		input \
		--placeholder "New session name: " \
		--no-show-help
)

if [ -n "$session_name" ]; then
	tmux new-session -d -s "$session_name"
	exit
fi
