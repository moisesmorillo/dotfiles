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
readonly ICON_MODEL=''        # User specified icon for model (gear/cog icon)
readonly ICON_DIR='󰧚'          # User specified icon for directory (folder icon)
readonly ICON_GIT_BRANCH=''   # User specified icon for git (git branch icon)
readonly ICON_GIT_CLEAN=''    # Nerd Font check icon (U+F00C)
readonly ICON_GIT_DIRTY=''    # Nerd Font dot/circle icon (U+F111)
readonly ICON_OUTPUT_STYLE='' # User specified icon for output style (settings/gear icon)
readonly ICON_COST="💰"         # Keep money icon (unchanged)
readonly SEPARATOR=""         # Nerd Font separator (U+E0B1)

# Parse input JSON
input=$(cat)
model_name=$(echo "$input" | jq -r '.model.display_name')
output_style=$(echo "$input" | jq -r '.output_style.name')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')

# Format cost information
cost_info=$(bunx ccusage daily --json | jq -r --arg today "$(date '+%Y-%m-%d')" '.daily[] | select(.date == $today) | .modelBreakdowns | map(.cost) | add | "$" + (. * 100 | round / 100 | tostring)')

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
			git_status_icon="${ICON_GIT_DIRTY}${status_short}"
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

printf " %s %b%s %b%s%b" "${SEPARATOR}" "${PINE}" "${ICON_OUTPUT_STYLE}" "${FOAM}" "output: ${output_style}" "${RESET}"

# Add cost info if available
if [ -n "$cost_info" ]; then
	printf " %s %b%s %b%s%b" "${SEPARATOR}" "${LOVE}" "${ICON_COST}" "${GOLD}" "${cost_info}" "${RESET}"
fi

printf "\n"
