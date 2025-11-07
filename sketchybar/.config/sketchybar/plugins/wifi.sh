#!/bin/bash

source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/colors.sh"

# Get WiFi info
WIFI_SSID=$(networksetup -getairportnetwork en0 | awk -F': ' '{print $2}')

if [[ $WIFI_SSID == "You are not associated with an AirPort network." ]] || [[ -z $WIFI_SSID ]]; then
  ICON=$WIFI_DISCONNECTED
  LABEL="Disconnected"
  COLOR=$RED
else
  ICON=$WIFI_CONNECTED
  LABEL="$WIFI_SSID"
  COLOR=$GREEN
fi

sketchybar --set $NAME icon="$ICON" \
                       icon.color=$COLOR \
                       label="$LABEL"
