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

		# The copy also carries every managed single file (AGENTS.md, mcp.json, extension
		# sources, ...). Stow refuses to link over a plain file, so ask it which targets
		# conflict and drop the copies that are byte-identical to the repository file.
		# Runtime files that Stow ignores never show up here, so they are kept.
		# A dry run with conflicts exits non-zero on purpose, hence the `|| true`.
		if command -v stow >/dev/null 2>&1; then
			{ stow -n -d "$ROOT_DIR" -t "$HOME" pi 2>&1 || true; } |
				sed -n 's/.*over existing target \(.*\) since neither a link nor a directory.*/\1/p' |
				while IFS= read -r target; do
					copy="$HOME/$target"
					source="$ROOT_DIR/pi/$target"
					if [ -f "$copy" ] && [ ! -L "$copy" ] && cmp -s "$copy" "$source"; then
						rm "$copy"
						echo "prepare-pi-home: removed migrated copy of $target so Stow can link it"
					else
						echo "prepare-pi-home: keeping $copy (differs from the repository); Stow will report it" >&2
					fi
				done
		fi
	fi
fi

# Prevent Stow's directory folding from making ~/.pi itself a symlink into the repo.
mkdir -p "$PI_HOME/agent"

# Plannotator keeps drafts and plan versions in ~/.plannotator next to its config.json.
# Pre-create the directory so Stow links only config.json instead of folding the
# whole directory, which would write that runtime state into the repository.
mkdir -p "$HOME/.plannotator"
