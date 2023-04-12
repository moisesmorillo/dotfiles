#!/bin/bash

function get_os_name() {
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "macos"
  elif [[ "$(uname)" == "Linux" ]]; then
    if [ -r /etc/os-release ]; then
      . /etc/os-release
      if [[ "$ID" == "debian" ]]; then
        echo "debian"
      elif [[ "$ID" == "ubuntu" ]]; then
        echo "ubuntu"
      elif [[ "$ID" == "fedora" ]]; then
        echo "fedora"
      else
        echo "unknown"
      fi
    else
      echo "unknown"
    fi
  else
    echo "unknown"
  fi
}