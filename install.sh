if [ -n "$CODESPACES" ]; then
  echo "***Loading Codespaces Dotfiles***"
  chmod +x ./scripts/install-codespaces.sh
  . ./scripts/install-codespaces.sh
else
    . ./scripts/utils.sh
    os_name=$(get_os_name)
    if [[ "$os_name" == "macos" ]]; then
      echo "***Loading MasOS Dotfiles***"
      chmod +x ./scripts/install-mac.sh
      . ./scripts/install-mac.sh
    fi
fi
