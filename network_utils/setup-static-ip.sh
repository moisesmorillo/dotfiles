#!/bin/bash

set -euo pipefail

# Default values
DEFAULT_IP="192.168.1.4"
DEFAULT_SUBNET="255.255.255.0"
DEFAULT_ROUTER="192.168.1.1"
DEFAULT_DNS1="1.1.1.1"
DEFAULT_DNS2="8.8.8.8"
DEFAULT_INTERFACE="USB 10/100/1000 LAN"

read -r -p "🛠️ Enter the desired static IP (default: $DEFAULT_IP): " STATIC_IP
read -r -p "📐 Enter the subnet mask (default: $DEFAULT_SUBNET): " SUBNET_MASK
read -r -p "🌐 Enter the router/gateway IP (default: $DEFAULT_ROUTER): " ROUTER
read -r -p "🧭 Primary DNS (default: $DEFAULT_DNS1): " DNS1
read -r -p "🧭 Secondary DNS (default: $DEFAULT_DNS2): " DNS2
read -r -p "🔌 Network Interface Name (default: $DEFAULT_INTERFACE): " INTERFACE_NAME

STATIC_IP="${STATIC_IP:-$DEFAULT_IP}"
SUBNET_MASK="${SUBNET_MASK:-$DEFAULT_SUBNET}"
ROUTER="${ROUTER:-$DEFAULT_ROUTER}"
DNS1="${DNS1:-$DEFAULT_DNS1}"
DNS2="${DNS2:-$DEFAULT_DNS2}"
INTERFACE_NAME="${INTERFACE_NAME:-$DEFAULT_INTERFACE}"

function log_info() {
	echo -e "\033[1;34m[INFO]\033[0m $1"
}

function log_error() {
	echo -e "\033[1;31m[ERROR]\033[0m $1" >&2
}

log_info "Assigning static IP $STATIC_IP to interface '$INTERFACE_NAME'..."

if ! sudo networksetup -setmanual "$INTERFACE_NAME" "$STATIC_IP" "$SUBNET_MASK" "$ROUTER"; then
	log_error "❌ Failed to assign the static IP."
	exit 1
fi

log_info "Setting DNS servers: $DNS1, $DNS2..."
if ! sudo networksetup -setdnsservers "$INTERFACE_NAME" "$DNS1" "$DNS2"; then
	log_error "❌ Failed to configure DNS servers."
	exit 1
fi

log_info "✅ Configuration completed. Interface status:"

DEVICE=$(networksetup -listallhardwareports | awk -v intf="$INTERFACE_NAME" '
    /Hardware Port/ { port = $0; sub(/^Hardware Port: /, "", port) }
    /Device/ && port == intf { sub(/^Device: /, "", $0); print; exit }
')

if [[ -n "$DEVICE" ]]; then
	ifconfig "$DEVICE"
else
	log_error "Could not find the device for interface '$INTERFACE_NAME'."
fi
