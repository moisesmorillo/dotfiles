#!/bin/bash

# Rose Pine Status Line for Claude Code (Max Subscription)
# Color palette: https://rosepinetheme.com/palette/

# Rosé Pine True Color Definitions (24-bit)
# https://rosepinetheme.com/palette/
readonly TEXT="\033[38;2;224;222;244m"   # #e0def4 (text)
readonly SUBTLE="\033[38;2;110;106;134m" # #6e6a86 (subtle)
readonly MUTED="\033[38;2;144;140;170m"  # #908caa (muted)
readonly LOVE="\033[38;2;235;111;146m"   # #eb6f92 (love - red/pink)
readonly GOLD="\033[38;2;246;193;119m"   # #f6c177 (gold - yellow)
readonly ROSE="\033[38;2;234;154;151m"   # #ea9a97 (rose - light pink)
readonly PINE="\033[38;2;49;116;143m"    # #31748f (pine - dark blue)
readonly FOAM="\033[38;2;156;207;216m"   # #9ccfd8 (foam - cyan/green)
readonly IRIS="\033[38;2;196;167;231m"   # #c4a7e7 (iris - purple)
readonly HLLOW="\033[38;2;33;32;46m"     # #21202e (highlight low)
readonly RESET="\033[0m"

# Nerd Font Icons
readonly ICON_MODEL=''
readonly ICON_DIR='󰧚'
readonly ICON_GIT_BRANCH=''
readonly ICON_GIT_CLEAN=''
readonly ICON_GIT_DIRTY='󰷈'
readonly ICON_CONTEXT='󰊠'
readonly ICON_INPUT_TOKEN="↓"
readonly ICON_OUTPUT_TOKEN="↑"
readonly ICON_DURATION='󰔛'
readonly ICON_LINES_ADD='󰜛'
readonly ICON_LINES_DEL='󰜙'
readonly SEPARATOR=""

# Parse input JSON (provided by Claude Code via stdin)
input=$(cat)
model_name=$(echo "$input" | jq -r '.model.display_name')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')

# Context window
ctx_used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
total_in_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_out_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')

# Session duration
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# Format tokens as human-readable (e.g., 89.2K, 1.3M)
format_tokens() {
	local tokens=$1
	if [ "$tokens" -ge 1000000 ]; then
		printf "%.1fM" "$(echo "$tokens / 1000000" | bc -l)"
	elif [ "$tokens" -ge 1000 ]; then
		printf "%.1fK" "$(echo "$tokens / 1000" | bc -l)"
	else
		printf "%d" "$tokens"
	fi
}

# Format duration from ms to human-readable
format_duration() {
	local ms=$1
	local total_secs=$((ms / 1000))
	local hours=$((total_secs / 3600))
	local mins=$(((total_secs % 3600) / 60))
	if [ "$hours" -gt 0 ]; then
		printf "%dh%02dm" "$hours" "$mins"
	elif [ "$mins" -gt 0 ]; then
		printf "%dm" "$mins"
	else
		printf "%ds" "$total_secs"
	fi
}

# Build the context window progress bar
build_progress_bar() {
	local pct=$1
	local bar_width=16
	local filled=$((pct * bar_width / 100))
	local empty=$((bar_width - filled))

	# Color based on usage thresholds
	local bar_color
	if [ "$pct" -ge 85 ]; then
		bar_color="${LOVE}"
	elif [ "$pct" -ge 60 ]; then
		bar_color="${GOLD}"
	else
		bar_color="${PINE}"
	fi

	# Build bar string
	local bar=""
	for ((i = 0; i < filled; i++)); do bar+="█"; done
	for ((i = 0; i < empty; i++)); do bar+="░"; done

	printf "%b%s%b%s %b%d%%%b" "${bar_color}" "${bar:0:$filled}" "${SUBTLE}" "${bar:$filled}" "${bar_color}" "$pct" "${RESET}"
}

# Format values
in_tokens_fmt=$(format_tokens "$total_in_tokens")
out_tokens_fmt=$(format_tokens "$total_out_tokens")
duration_fmt=$(format_duration "$duration_ms")

# Get git information
git_branch=""
git_status_icon=""
git_status_color=""
if \cd "$current_dir" 2>/dev/null; then
	branch=$(git branch --show-current 2>/dev/null || echo '')
	if [ -n "$branch" ]; then
		git_branch="$branch"
		status_short=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
		if [ "$status_short" -gt 0 ]; then
			git_status_color="${GOLD}"
			git_status_icon="${ICON_GIT_DIRTY}${status_short}"
		else
			git_status_color="${PINE}"
			git_status_icon="${ICON_GIT_CLEAN}"
		fi
	fi
fi

dir_name=$(basename "$current_dir")

# === Build status line ===

# Model
printf " %b%s %b%s%b" "${IRIS}" "${ICON_MODEL}" "${TEXT}" "${model_name}" "${RESET}"

# Directory
printf " %s %b%s %b%s%b" "${SEPARATOR}" "${GOLD}" "${ICON_DIR}" "${ROSE}" "${dir_name}" "${RESET}"

# Git
if [ -n "$git_branch" ]; then
	printf " %s %b%s %b%s %b%s%b" "${SEPARATOR}" "${FOAM}" "${ICON_GIT_BRANCH}" "${TEXT}" "${git_branch}" "${git_status_color}" "${git_status_icon}" "${RESET}"
fi

# Context window progress bar
printf " %s %b%s %b" "${SEPARATOR}" "${FOAM}" "${ICON_CONTEXT}" "${RESET}"
build_progress_bar "$ctx_used_pct"

# Session tokens (in / out) — foam (green) for input, love (red) for output
printf " %s %b%s %b%s  %b%s %b%s%b" "${SEPARATOR}" "${FOAM}" "${ICON_INPUT_TOKEN}" "${FOAM}" "${in_tokens_fmt}" "${LOVE}" "${ICON_OUTPUT_TOKEN}" "${LOVE}" "${out_tokens_fmt}" "${RESET}"

# Session duration
printf " %s %b%s %b%s%b" "${SEPARATOR}" "${GOLD}" "${ICON_DURATION}" "${TEXT}" "${duration_fmt}" "${RESET}"

# Lines changed — foam (green) for added, love (red) for removed
if [ "$lines_added" -gt 0 ] || [ "$lines_removed" -gt 0 ]; then
	printf " %s %b%s %b%s  %b%s %b%s%b" "${SEPARATOR}" "${FOAM}" "${ICON_LINES_ADD}" "${FOAM}" "${lines_added}" "${LOVE}" "${ICON_LINES_DEL}" "${LOVE}" "${lines_removed}" "${RESET}"
fi

printf "\n"
