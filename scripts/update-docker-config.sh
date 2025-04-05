#!/bin/bash

CONFIG_FILE="$HOME/.docker/config.json"

EXTRA_DIRS="/opt/homebrew/lib/docker/cli-plugins"

mkdir -p "$HOME/.docker"
touch "$CONFIG_FILE"

if [[ ! -s "$CONFIG_FILE" ]]; then
	echo '{}' >"$CONFIG_FILE"
fi

jq --argjson dirs '["'"$EXTRA_DIRS"'"]' \
	'.cliPluginsExtraDirs = $dirs' "$CONFIG_FILE" >"$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
