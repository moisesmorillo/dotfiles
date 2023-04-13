if [ -n "$CODESPACES" ]; then
  echo "***Loading Codespaces Dotfiles***"
  chmod +x ./scripts/install-codespaces.sh
  . ./scripts/install-codespaces.sh
else
    . ./scripts/utils.sh
    os_name=$(get_os_name)
    if [[ "$os_name" == "fedora" ]]; then
        # Install Fedora Packages
        . ./scripts/install-fedora.sh
    elif [[ "$os_name" == "macos" ]]; then
        # Install Mac Packages
        . ./scripts/install-mac.sh
    fi
fi
