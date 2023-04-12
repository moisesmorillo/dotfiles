#!/bin/bash

# Dectect OS
if [[ "$(uname)" == "Darwin" ]]; then
  echo "MacOS"
elif [[ "$(uname)" == "Linux" ]]; then
  # Detect supported Linux version
  if [ -r /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
      echo "Debian or Ubuntu: $ID"
    elif [[ "$ID" == "fedora" ]]; then
      echo "Fedora"
    fi
  fi
  echo "Unsupported Linux Version, exiting now..."
  exit 1
else
  echo "Unsupported OS"
  exit 1
fi

