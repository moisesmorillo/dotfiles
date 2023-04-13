. ./scripts/utils.sh

os_name=$(get_os_name)

if [[ "$os_name" == "debian" || "$os_name" == "ubuntu" ]]; then
    # Install Debian/Ubuntu Packages
    . ./scripts/install-debian.sh
elif [[ "$os_name" == "fedora" ]]; then
    # Install Fedora Packages
    . ./scripts/install-fedora.sh
elif [[ "$os_name" == "macos" ]]; then
    # Install Mac Packages
    . ./scripts/install-mac.sh
fi
