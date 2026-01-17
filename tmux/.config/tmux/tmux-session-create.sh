#!/usr/bin/env zsh

# Prompt for session name
read "name?Session name: "

# Replace spaces with hyphens
name="${name// /-}"

# Create session in detached mode if name is not empty
if [[ -n "$name" ]]; then
	session_name=$(basename "$PWD")
	[[ "$session_name" == "/" ]] && session_name="root"
	tmux new-session -d -s "$name" -c "$PWD" -n "$session_name" 2>/dev/null

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
