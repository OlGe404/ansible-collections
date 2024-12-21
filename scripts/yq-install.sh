#!/bin/bash

help() {
    cat <<EOF
Usage: ./$(basename "$0")

Description:
  Installs yq on linux systems, if it's not already installed.
  If you want to install yq on a non-linux system, see "https://github.com/mikefarah/yq/?tab=readme-ov-file#install".

Options:
  -h, --help    Show this help message and exit.

EOF
}

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    help
    exit 0
fi

if ! uname | grep -i -q "linux"; then
    echo -e "🚨 ERROR: This is not a linux machine. This script won't work here. \n"
    help
    exit 1
fi

if yq --version > /dev/null; then
  echo -e "🚨 ERROR: yq is already installed. \n"
  help
  exit 1
fi

sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq
sudo chmod +x /usr/bin/yq
