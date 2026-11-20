#!/usr/bin/env bash
# Make Rex reachable over SSH on this Mac.
#
# A Rex client (the iPhone app, or `rex -S ssh://user@host`) logs in with SSH and runs
# `rex` on this machine. An SSH login does not load .zshrc, so it does not find the
# rex binary inside the app bundle. Rex also looks in ~/.local/bin, so link it there.
# The link points to Versions/Current and stays valid after Rex updates.
#
# Safe to run again. Run it alone on a Mac that already has the dotfiles:
#   bash scripts/setup-rex.sh
set -euo pipefail

REX_BIN="$HOME/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS/rex"
LINK="$HOME/.local/bin/rex"

if [ ! -x "$REX_BIN" ]; then
	echo "setup-rex: Rex is not installed (no $REX_BIN). Install Rex, open it once, then run this again."
	exit 0
fi

mkdir -p "$(dirname "$LINK")"
ln -sfn "$REX_BIN" "$LINK"
echo "setup-rex: $LINK -> $REX_BIN"

# SSH access also needs Remote Login (System Settings > General > Sharing).
if nc -z -G 2 127.0.0.1 22 >/dev/null 2>&1; then
	echo "setup-rex: Remote Login is on."
else
	echo "setup-rex: Remote Login is off. Turn it on in System Settings > General > Sharing."
fi
