#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Get CPU usage
CPU_USAGE=$(ps -A -o %cpu | awk '{s+=$1} END {print s}')
CPU_USAGE=$(printf "%.0f" $CPU_USAGE)

# Determine color based on usage
if [ $CPU_USAGE -gt 80 ]; then
  COLOR=$RED
elif [ $CPU_USAGE -gt 50 ]; then
  COLOR=$ORANGE
else
  COLOR=$GREEN
fi

sketchybar --set $NAME label="${CPU_USAGE}%" \
                       icon.color=$COLOR
