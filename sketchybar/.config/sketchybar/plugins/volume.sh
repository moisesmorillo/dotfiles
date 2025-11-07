#!/bin/bash

source "$HOME/.config/sketchybar/icons.sh"

# Get current volume
VOLUME=$(osascript -e "output volume of (get volume settings)")

# Determine icon based on volume level
case ${VOLUME} in
  100|9[0-9]) ICON=$VOLUME_100 ;;
  8[0-9]|7[0-9]|6[0-9]) ICON=$VOLUME_66 ;;
  5[0-9]|4[0-9]|3[0-9]) ICON=$VOLUME_33 ;;
  2[0-9]|1[0-9]) ICON=$VOLUME_10 ;;
  [0-9]) ICON=$VOLUME_0 ;;
  *) ICON=$VOLUME_100 ;;
esac

sketchybar --set $NAME icon="$ICON" label="$VOLUME%"
