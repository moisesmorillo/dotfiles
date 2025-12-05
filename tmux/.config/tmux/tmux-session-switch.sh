#!/bin/zsh

# Get a list of tmux sessions
sessions=$(tmux list-sessions -F "#{session_name}" | sort -u)

# Use fzf to select a session
selected_session=$(
	echo "$sessions" | fzf \
		--reverse \
		--no-info \
		--border \
		--ghost="Select tmux session: " \
		--no-preview
)

# If a session was selected, attach to it
if [ -n "$selected_session" ]; then
	tmux switch-client -t "$selected_session"
fi

# This make indicator in fzf completely invisible
# --pointer="" \
# --color="bg+:-1,fg+:-1,hl+:-1")
#
