#!/usr/bin/env zsh

# Main function to generate the process tree
function generate_list() {
	# Tmux output format
	FORMAT="#{session_name}:#{window_index}:#{window_name}:#{window_active}:#{pane_index}:#{pane_active}:#{pane_current_path}:#{pane_current_command}"

	tmux list-panes -a -F "$FORMAT" | awk -F: '
    {
        session_name = $1
        win_idx = $2
        win_name = $3
        win_active = $4
        pane_idx = $5
        pane_active = $6
        pane_path = $7
        pane_cmd = $8

        # 1. SESSION HEADER
        if (session_name != current_session) {
            # Hidden ID: session_name:root:root
            printf "%s:root:root \033[1;35m %s\033[0m\n", session_name, session_name
            current_session = session_name
            current_win_idx = ""
        }

        # 2. WINDOW BRANCH
        if (win_idx != current_win_idx) {
            win_marker = " "
            if (win_active == 1) win_marker = "*"
            # Hidden ID: session_name:win_idx:root
            printf "%s:%s:root \033[0;36m  ├─ %s %d: %s\033[0m\n", session_name, win_idx, win_marker, win_idx, win_name
            current_win_idx = win_idx
        }

        # 3. PANE LEAF
        pane_marker = " "
        if (pane_active == 1) pane_marker = "●"
        # Hidden ID: session_name:win_idx:pane_idx
        printf "%s:%s:%s \033[0;37m    │  ├─ %s %d: \033[1;32m %s\033[0m\n", session_name, win_idx, pane_idx, pane_marker, pane_idx, pane_cmd
    }'
}

# --- RELOAD LOGIC ---
if [[ "$1" == "--list" ]]; then
	generate_list
	exit 0
fi

# --- DELETE LOGIC (Ctrl-x) ---
DELETE_LOGIC="
    target=\$(echo {} | awk '{print \$1}');
    sess=\$(echo \$target | cut -d: -f1);
    win=\$(echo \$target | cut -d: -f2);
    pane=\$(echo \$target | cut -d: -f3);

    if [ \"\$win\" = \"root\" ]; then
        tmux kill-session -t \"\$sess\";
    elif [ \"\$pane\" = \"root\" ]; then
        tmux kill-window -t \"\${sess}:\${win}\";
    else
        tmux kill-pane -t \"\${sess}:\${win}.\${pane}\";
    fi
"

# --- MAIN EXECUTION ---
selected=$(generate_list | fzf \
	--ansi \
	--reverse \
	--border \
	--prompt="Switch to: " \
	--pointer="▶" \
	--header=$'Enter: Switch | Ctrl-x: Kill\nCtrl-n: New Session' \
	--ghost="Session > Window > Pane" \
	--with-nth=2.. \
	--delimiter=" " \
	--preview-window="right:70%:nowrap" \
	--preview '
        target=$(echo {} | awk "{print \$1}")
        sess=$(echo $target | cut -d: -f1)
        win=$(echo $target | cut -d: -f2)
        pane=$(echo $target | cut -d: -f3)

        if [ "$win" = "root" ]; then
             tmux capture-pane -e -J -p -t "${sess}"
        elif [ "$pane" = "root" ]; then
             tmux capture-pane -e -J -p -t "${sess}:${win}"
        else
             tmux capture-pane -e -J -p -t "${sess}:${win}.${pane}"
        fi
    ' \
	--bind "enter:accept" \
	--bind "ctrl-x:execute-silent($DELETE_LOGIC)+reload($0 --list)" \
	--bind "ctrl-n:print-query") # Print what the user typed instead of the selection

# --- ACTION HANDLER ---
if [[ -n "$selected" ]]; then
	# Check if the output matches our ID pattern (session:win:pane ...)
	# If it contains colons in that specific format, it's a selection from the list.
	if [[ "$selected" =~ ^[^:]+:[^:]+:[^:]+.*$ ]]; then
		target=$(echo "$selected" | awk '{print $1}')
		sess=$(echo "$target" | cut -d: -f1)
		win=$(echo "$target" | cut -d: -f2)
		pane=$(echo "$target" | cut -d: -f3)

		if [[ "$win" == "root" ]]; then
			tmux switch-client -t "$sess"
		elif [[ "$pane" == "root" ]]; then
			tmux switch-client -t "${sess}:${win}"
		else
			tmux switch-client -t "${sess}:${win}.${pane}"
		fi
	else
		# If it DOESN'T match the pattern, it means user pressed Ctrl-n (New Session)
		# using the raw text query they typed.

		# 1. Create the session in detached mode
		# (2>/dev/null hides error if session name is empty or invalid)
		tmux new-session -d -s "$selected" 2>/dev/null

		# 2. Switch to it if creation was successful
		if [ $? -eq 0 ]; then
			tmux switch-client -t "$selected"
		fi
	fi
fi
