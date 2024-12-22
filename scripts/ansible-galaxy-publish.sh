#!/bin/bash -e

ROOT=$(git rev-parse --show-toplevel)

help() {
    cat <<EOF
Usage: ./$(basename "$0") <API_TOKEN>
Prerequisites: curl, yq and ansible-galaxy have to be installed.

Description:
  Packages the "olge404.unix" ansible collection and publishes it to ansible-galaxy hub,
  if the value of "version" in "$ROOT/galaxy.yml" doesn't exist on ansible-galaxy hub yet.

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

if ! curl --help > /dev/null 2>&1; then
  echo -e "🚨 ERROR: Cannot perform "curl --help". Is curl installed? \n"
  help
  exit 1
fi

if ! yq --version > /dev/null; then
  echo -e "🚨 ERROR: Cannot perform "yq --version". Is yq installed? \n"
  help
  exit 1
fi

if ! ansible-galaxy --version > /dev/null 2>&1; then
  echo -e "🚨 ERROR: Cannot perform "ansible-galaxy --version". Is ansible-galaxy installed? \n"
  help
  exit 1
fi

GALAXY_FILE_VERSION=$(yq '.version' galaxy.yml)
GALAXY_HUB_RESPONSE=$(curl -s -L -o /dev/null -w "%{http_code}" "https://beta-galaxy.ansible.com/api/v3/plugin/ansible/content/published/collections/index/olge404/unix/versions/$GALAXY_FILE_VERSION/")

if [ "$GALAXY_HUB_RESPONSE" -eq 404 ]; then
  ansible-galaxy collection build --force "$ROOT"
  COLLECTION_TAR_GZ=$(find . -name "olge404-unix-*.tar.gz")
  ansible-galaxy collection publish --token "$1" "$COLLECTION_TAR_GZ" && rm "$COLLECTION_TAR_GZ"

elif [ "$GALAXY_HUB_RESPONSE" -eq 200 ]; then
  echo -e "🚨 ERROR: Version $GALAXY_FILE_VERSION of olge404.unix already exists on ansible-galaxy hub. \n"
  help
  exit 1
fi
