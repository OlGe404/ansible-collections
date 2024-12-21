#!/bin/bash -e

ROOT=$(git rev-parse --show-toplevel)

help() {
    cat <<EOF
Usage: ./$(basename "$0")
Prerequisites: yq, ansible and ansible-galaxy have to be installed.

Description:
  Installs the ansible-galaxy requirements for the "olge404.unix" ansible collection locally. Requirements are extracted
  from "dependencies" section of the "$ROOT/galaxy.yml" file.

  If a virtualenv for python3 exists at "$ROOT/.venv/bin/activate", it is used.

Options:
  -h, --help    Show this help message and exit.

EOF
}

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    help
    exit 0
fi

if ! yq --version > /dev/null; then
  echo -e "🚨 ERROR: Cannot perform "yq --version". Is yq installed? \n"
  help
  exit 1
fi

if ! ansible --version > /dev/null 2>&1; then
  echo -e "🚨 ERROR: Cannot perform "ansible --version". Is ansible installed? \n"
  help
  exit 1
fi

if ! ansible-galaxy --version > /dev/null 2>&1; then
  echo -e "🚨 ERROR: Cannot perform "ansible-galaxy --version". Is ansible-galaxy installed? \n"
  help
  exit 1
fi

if [ -d "$ROOT/.venv" ]; then
    source "$ROOT/.venv/bin/activate"
fi

DEPENDENCIES=$(yq eval '.dependencies | keys | .[]' "$ROOT/galaxy.yml")
for dep in $DEPENDENCIES; do
  # Extract the version of the dependency using ["key"] syntax
  version=$(yq eval ".dependencies[\"${dep}\"]" "$ROOT/galaxy.yml")
  
  echo "Installing collection: $dep==$version"
  ansible-galaxy collection install --force "$dep==$version"
done