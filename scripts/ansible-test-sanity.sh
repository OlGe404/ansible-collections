#!/bin/bash -e

ROOT=$(git rev-parse --show-toplevel)
TMP="/tmp/ansible_collections"

help() {
    cat <<EOF
Usage: ./$(basename "$0")
Prerequisites: Docker, ansible-test and ansible-galaxy have to be installed.

Description:
  Installs the "olge404.unix" ansible collection at "$TMP" and runs "ansible-test sanity" in the default docker container for it.
  If a virtualenv for python3 exists at "$ROOT/.venv/bin/activate", it is used.

Options:
  -h, --help    Show this help message and exit.

EOF
}

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    help
    exit 0
fi

if ! ansible-test --version > /dev/null 2>&1; then
  echo -e "🚨 ERROR: Cannot perform "ansible-test --version". Is ansible-test installed? \n"
  help
  exit 1
fi

if ! ansible-galaxy --version > /dev/null 2>&1; then
  echo -e "🚨 ERROR: Cannot perform "ansible-galaxy --version". Is ansible-galaxy installed? \n"
  help
  exit 1
fi

if ! docker ps > /dev/null 2>&1; then
  echo -e "🚨 ERROR: Cannot perform "docker ps". Is the docker daemon installed and running? \n"
  help
  exit 1
fi

if [ -d "$ROOT/.venv" ]; then
    source "$ROOT/.venv/bin/activate"
fi

ansible-galaxy collection install --force "$ROOT" -p "$TMP"
cd "$TMP/olge404/unix" && ansible-test sanity --docker default && rm -rf "$TMP"
