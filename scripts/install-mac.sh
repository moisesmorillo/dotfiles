#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

### Select environment ###
echo ""
echo "Select your dotfiles environment:"
echo "  1) personal — base + personal apps (default)"
echo "  2) work     — base + work apps"
echo "  3) all      — base + personal + work apps"
echo ""
read -rp "Enter choice [1]: " env_choice
case "$env_choice" in
2) DOTFILES_ENV="work" ;;
3) DOTFILES_ENV="all" ;;
*) DOTFILES_ENV="personal" ;;
esac
echo "Environment set to: $DOTFILES_ENV"
echo ""

### Uninstall Brew ###
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

### Install Brew ###
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

if ! command -v brew &>/dev/null; then
	echo "brew could not be found, exiting"
	exit 1
fi

### Install mise ###
curl https://mise.run | sh
eval "$(~/.local/bin/mise activate bash)"

### Update Brew ###
brew update && brew upgrade

### Install from Brewfiles (layered by environment)
echo "Installing Brewfile.base..."
if ! brew bundle install --file=./brew/Brewfile.base; then
	echo "brew bundle (base) failed, exiting"
	exit 1
fi

if [[ "$DOTFILES_ENV" == "personal" || "$DOTFILES_ENV" == "all" ]]; then
	echo "Installing Brewfile.personal..."
	if ! brew bundle install --file=./brew/Brewfile.personal; then
		echo "brew bundle (personal) failed, exiting"
		exit 1
	fi
fi

if [[ "$DOTFILES_ENV" == "work" || "$DOTFILES_ENV" == "all" ]]; then
	echo "Installing Brewfile.work..."
	if ! brew bundle install --file=./brew/Brewfile.work; then
		echo "brew bundle (work) failed, exiting"
		exit 1
	fi
fi

### Update docker config file
. ./scripts/update-docker-config.sh

### Create default colima machine
colima start --cpu 4 --memory 6 --disk 50 --vm-type vz --mount-type virtiofs

### Install Tpm ###
rm -rf ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

### Set defaults mac os
chmod +x "${SCRIPT_DIR}/macos-settings.sh"
#shellcheck disable=SC1091
source "${SCRIPT_DIR}/macos-settings.sh"

### Clone and set dotfiles ###
for pattern in \
	~/.config/nvim \
	~/.config/tmux \
	~/.local/share/nvim \
	~/.config/lazygit \
	~/.zshrc* \
	~/.tmux \
	~/.zprofile* \
	~/.zsh_history* \
	~/.zsh_sessions/ \
	~/.zshrc \
	~/.zshenv; do
	rm -rf "$pattern" 2>/dev/null
done

# Change to root directory before running stow
cd "$ROOT_DIR" || exit
# shellcheck disable=SC2035
/opt/homebrew/bin/stow -R -t "$HOME" */

# Post commands
mise install
mise exec -- bat cache --build
