#!/bin/bash

source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/colors.sh"

# Get battery percentage
PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

# Determine icon based on battery level
if [[ $CHARGING != "" ]]; then
  ICON=$BATTERY_CHARGING
  COLOR=$GREEN
else
  case ${PERCENTAGE} in
    100|9[0-9]) ICON=$BATTERY_100; COLOR=$GREEN ;;
    8[0-9]|7[0-9]|6[0-9]) ICON=$BATTERY_75; COLOR=$GREEN ;;
    5[0-9]|4[0-9]|3[0-9]) ICON=$BATTERY_50; COLOR=$YELLOW ;;
    2[0-9]|1[0-9]) ICON=$BATTERY_25; COLOR=$ORANGE ;;
    *) ICON=$BATTERY_0; COLOR=$RED ;;
  esac
fi

sketchybar --set $NAME icon="$ICON" \
                       icon.color=$COLOR \
                       label="${PERCENTAGE}%"
