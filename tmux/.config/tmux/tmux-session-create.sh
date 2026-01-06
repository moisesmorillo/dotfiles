#!/usr/bin/env zsh

# Prompt for session name
read "name?Session name: "

# Create session in detached mode if name is not empty
if [[ -n "$name" ]]; then
	tmux new-session -d -s "$name" 2>/dev/null

	# Switch to the new session if creation was successful
	if [ $? -eq 0 ]; then
		tmux switch-client -t "$name"
	else
		echo "Failed to create session '$name'. It may already exist."
		sleep 2
	fi
else
	echo "Session name cannot be empty."
	sleep 2
fi
