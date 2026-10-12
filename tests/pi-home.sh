#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

fail() {
	echo "FAIL: $*" >&2
	exit 1
}

fixture="$TMP_DIR/dotfiles"
home="$TMP_DIR/home"
mkdir -p "$fixture/pi/.pi/agent/agents" "$fixture/pi/.pi/agent/prompts" \
	"$fixture/pi/.pi/agent/themes" "$fixture/pi/.pi/agent/sessions" \
	"$fixture/pi/.pi/agent/npm/cache" "$home"
mkdir -p "$fixture/scripts" "$fixture/pi/.plannotator"
printf '{"agentTool": true}\n' >"$fixture/pi/.plannotator/config.json"
cp "$ROOT_DIR/scripts/prepare-pi-home.sh" "$fixture/scripts/prepare-pi-home.sh"
cp "$ROOT_DIR/pi/.stow-local-ignore" "$fixture/pi/.stow-local-ignore"
printf '{"defaultModel":"fixture","custom":"preserve"}\n' >"$fixture/pi/.pi/agent/settings.json"
printf 'runtime session\n' >"$fixture/pi/.pi/agent/sessions/session.jsonl"
printf 'installed package\n' >"$fixture/pi/.pi/agent/npm/cache/package.txt"
printf 'review agent\n' >"$fixture/pi/.pi/agent/agents/review.md"
printf 'prompt\n' >"$fixture/pi/.pi/agent/prompts/review.md"
printf 'theme\n' >"$fixture/pi/.pi/agent/themes/rose.json"
mkdir -p "$home/.pi"
rmdir "$home/.pi"
ln -s "$fixture/pi/.pi" "$home/.pi"

HOME="$home" "$fixture/scripts/prepare-pi-home.sh"
[ ! -L "$home/.pi" ] || fail "a folded repository symlink must be migrated to a real home directory"
[ ! -L "$home/.pi/agent" ] || fail "Pi agent state directory must be a real directory"
jq -e '.custom == "preserve"' "$home/.pi/agent/settings.json" >/dev/null ||
	fail "migration must preserve the existing Pi settings"
[ -f "$home/.pi/agent/sessions/session.jsonl" ] || fail "migration must preserve session state"
[ -f "$home/.pi/agent/npm/cache/package.txt" ] || fail "migration must preserve installed package state"

stow -d "$fixture" -t "$home" pi
[ -L "$home/.pi/agent/agents" ] || fail "Stow must still link managed agent configuration"
[ -L "$home/.pi/agent/prompts" ] || fail "Stow must still link managed prompts"
[ -L "$home/.pi/agent/themes" ] || fail "Stow must still link managed themes"
[ ! -L "$home/.pi/agent/sessions" ] || fail "runtime sessions must remain outside the repository"
[ ! -L "$home/.pi/agent/npm" ] || fail "installed packages must remain outside the repository"

fresh_home="$TMP_DIR/fresh-home"
mkdir -p "$fresh_home"
HOME="$fresh_home" "$fixture/scripts/prepare-pi-home.sh"
stow -d "$fixture" -t "$fresh_home" pi
[ ! -L "$fresh_home/.pi" ] || fail "a fresh Stow install must not fold ~/.pi into the repository"
[ ! -L "$fresh_home/.pi/agent" ] || fail "a fresh install must keep ~/.pi/agent writable outside the repository"
[ ! -L "$fresh_home/.plannotator" ] || fail "a fresh install must not fold ~/.plannotator into the repository"
[ -L "$fresh_home/.plannotator/config.json" ] || fail "Stow must link the Plannotator config"

echo "PASS: Pi writable state stays outside the dotfiles repository"
