#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Get the current space
if [ "$SELECTED" = "true" ]; then
  sketchybar --set $NAME background.drawing=on \
                       background.color=$HIGHLIGHT_COLOR \
                       icon.color=$BLACK \
                       label.color=$BLACK
else
  sketchybar --set $NAME background.drawing=on \
                       background.color=$ITEM_BG_COLOR \
                       icon.color=$WHITE \
                       label.color=$WHITE
fi
