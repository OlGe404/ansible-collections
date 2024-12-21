#!/bin/bash -e

ROOT=$(git rev-parse --show-toplevel)

help() {
    cat <<EOF
Usage: ./$(basename "$0") <API_TOKEN>
Prerequisites: ansible-galaxy has to be installed.

Description:
  Packages the "olge404.unix" ansible collection and publishes it to ansible-galaxy hub.
  If a virtualenv for python3 exists at "$ROOT/.venv/bin/activate", it is used.

Arguments:
  API_TOKEN     Token to use for authentication against ansible-galaxy hub.

Options:
  -h, --help    Show this help message and exit.

EOF
}

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    help
    exit 0
fi

if [ -z "$1" ]; then
  echo -e "🚨 ERROR: The API_TOKEN arg is mandatory. \n"
  help
  exit 1
fi

if [ -d "$ROOT/.venv" ]; then
    source "$ROOT/.venv/bin/activate"
fi

if ! ansible-galaxy --version > /dev/null 2>&1; then
  echo -e "🚨 ERROR: Cannot perform "ansible-galaxy --version". Is ansible-galaxy installed? \n"
  help
  exit 1
fi

ansible-galaxy collection build --force "$ROOT"

COLLECTION_TAR_GZ=$(find . -name "olge404-unix-*.tar.gz")
ansible-galaxy collection publish --token "$1" "$COLLECTION_TAR_GZ" && rm "$COLLECTION_TAR_GZ"
