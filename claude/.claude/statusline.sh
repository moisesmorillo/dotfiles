#!/bin/bash

# Rose Pine Enhanced Status Line for Claude Code
# Color palette: https://rosepinetheme.com/palette/

# Rose Pine Color Definitions (using simpler ANSI codes for better compatibility)
readonly TEXT="\033[97m" # bright white (main text)
readonly LOVE="\033[91m" # bright red (red/pink)
readonly GOLD="\033[93m" # bright yellow (yellow/orange)
readonly ROSE="\033[95m" # bright magenta (light pink)
readonly PINE="\033[94m" # bright blue (blue)
readonly FOAM="\033[96m" # bright cyan (cyan)
readonly IRIS="\033[95m" # bright magenta (purple)
readonly RESET="\033[0m"

# JetBrains Mono Nerd Font Icons - User specified icons
readonly ICON_MODEL=''
readonly ICON_DIR='󰧚'
readonly ICON_GIT_BRANCH=''
readonly ICON_GIT_CLEAN=''
readonly ICON_GIT_DIRTY=''
readonly ICON_OUTPUT_STYLE=''
readonly ICON_COST="󰇁"
readonly ICON_INPUT_TOKEN=""
readonly ICON_OUTPUT_TOKEN=""
readonly SEPARATOR=""

# Parse input JSON
input=$(cat)
model_name=$(echo "$input" | jq -r '.model.display_name')
output_style=$(echo "$input" | jq -r '.output_style.name')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')

# Format cost information
cost_info_breakdowns=$(bunx ccusage daily --json | jq -r --arg today "$(date '+%Y-%m-%d')" '.daily[] | select(.date == $today) | .modelBreakdowns')
cost_info_total_price=" "$(echo "$cost_info_breakdowns" | jq -r '. | map(.cost) | add | (. * 100 | round / 100 | tostring)')
cost_info_input_tokens_quantity=" "$(echo "$cost_info_breakdowns" | jq -r '. | map(.inputTokens) | add | (. / 1000) | tostring + "K"')
cost_info_output_tokens_quantity=" "$(echo "$cost_info_breakdowns" | jq -r '. | map(.outputTokens) | add | (. / 1000 ) | tostring + "K"')

# Get git information
git_branch=""
git_status_icon=""
git_status_color=""
if cd "$current_dir" 2>/dev/null; then
	branch=$(git branch --show-current 2>/dev/null || echo '')
	if [ -n "$branch" ]; then
		git_branch="$branch"
		status_short=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
		if [ "$status_short" -gt 0 ]; then
			git_status_color="${GOLD}"
			git_status_icon="${ICON_GIT_DIRTY} ${status_short}"
		else
			git_status_color="${PINE}"
			git_status_icon="${ICON_GIT_CLEAN}"
		fi
	fi
fi

# Get directory name
dir_name=$(basename "$current_dir")

# Build the beautiful status line with Rose Pine colors and icons
printf " %b%s %b%s%b" "${IRIS}" "${ICON_MODEL}" "${TEXT}" "${model_name}" "${RESET}"
printf " %s %b%s %b%s%b" "${SEPARATOR}" "${GOLD}" "${ICON_DIR}" "${ROSE}" "${dir_name}" "${RESET}"

# Add git info if available
if [ -n "$git_branch" ]; then
	printf " %s %b%s %b%s %b%s%b" "${SEPARATOR}" "${FOAM}" "${ICON_GIT_BRANCH}" "${TEXT}" "${git_branch}" "${git_status_color}" "${git_status_icon}" "${RESET}"
fi

printf " %s %b%s %b%s%b" "${SEPARATOR}" "${ROSE}" "${ICON_OUTPUT_STYLE}" "${TEXT}" "output_style: ${output_style}" "${RESET}"

# Add cost info if available
if [ -n "$cost_info_breakdowns" ]; then
	printf " %s %b%s%s %s %b%s%s %s %b%s%s%b" "${SEPARATOR}" "${PINE}" "${ICON_COST}" "${cost_info_total_price}" "${SEPARATOR}" "${GOLD}" "${ICON_INPUT_TOKEN}" "${cost_info_input_tokens_quantity}" "${SEPARATOR}" "${LOVE}" "${ICON_OUTPUT_TOKEN}" "${cost_info_output_tokens_quantity}" "${RESET}"
fi

printf "\n"
