#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
PI_HOME="$HOME/.pi"
SOURCE_PI="$ROOT_DIR/pi/.pi"

if [ -L "$PI_HOME" ] && [ -d "$SOURCE_PI" ]; then
	CURRENT_PI_REAL="$(cd "$PI_HOME" && pwd -P)"
	SOURCE_PI_REAL="$(cd "$SOURCE_PI" && pwd -P)"
	if [ "$CURRENT_PI_REAL" = "$SOURCE_PI_REAL" ]; then
		# Preserve local Pi state, but let Stow recreate links for the managed config dirs.
		MIGRATION_DIR="$(mktemp -d "$HOME/.pi-migration.XXXXXX")"
		cp -a "$PI_HOME/." "$MIGRATION_DIR/"
		rm -rf "$MIGRATION_DIR/agent/agents" "$MIGRATION_DIR/agent/prompts" \
			"$MIGRATION_DIR/agent/themes"
		rm "$PI_HOME"
		mv "$MIGRATION_DIR" "$PI_HOME"
		echo "prepare-pi-home: migrated Pi state out of the dotfiles repository"
	fi
fi

# Prevent Stow's directory folding from making ~/.pi itself a symlink into the repo.
mkdir -p "$PI_HOME/agent"
