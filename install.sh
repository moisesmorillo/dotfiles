if [ -n "$CODESPACES" ]; then
	echo "***Loading Codespaces Dotfiles***"
	chmod +x ./scripts/install-codespaces.sh
	. ./scripts/install-codespaces.sh
elif [ -n "$REMOTE_CONTAINERS" ] || [ -n "$DEVCONTAINER" ] || [ -f /.dockerenv ] \
	|| grep -qa 'docker\|containerd\|kubepods' /proc/1/cgroup 2>/dev/null \
	|| [ -d /workspaces ]; then
	# devcontainer / Linux dev sandbox (e.g. the Saptiva workspace via the devcontainer
	# CLI — no VS Code, so the standard dotfiles client never runs; the meta-repo's
	# scripts/dotfiles.sh invokes this install.sh per the well-known dotfiles contract).
	echo "***Loading Devcontainer Dotfiles***"
	chmod +x ./scripts/install-devcontainer.sh
	. ./scripts/install-devcontainer.sh
else
	. ./scripts/utils.sh
	os_name=$(get_os_name)
	if [[ "$os_name" == "macos" ]]; then
		echo "***Loading MacOS Dotfiles***"
		chmod +x ./scripts/install-mac.sh
		. ./scripts/install-mac.sh
	fi
fi
