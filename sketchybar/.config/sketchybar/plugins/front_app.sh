#!/bin/bash

# Get the name of the currently focused application
FRONT_APP=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true')

sketchybar --set $NAME label="$FRONT_APP"
