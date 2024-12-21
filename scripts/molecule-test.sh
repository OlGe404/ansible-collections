#!/bin/bash -e

ROOT=$(git rev-parse --show-toplevel)

help() {
    cat <<EOF
Usage: ./$(basename "$0") [ROLE_NAME]
Prerequisites: Docker, ansible, molecule and molecule-plugins have to be installed.

Description:
  Run "molecule test" for a given ROLE_NAME or for all roles found at "$ROOT/roles", if ROLE_NAME is not provided.
  If a virtualenv for python3 exists at "$ROOT/.venv/bin/activate", it is used.

Arguments:
  ROLE_NAME    Name of the role to run "molecule test" for (optional).

Options:
  -h, --help    Show this help message and exit.

Examples:
    ./$(basename "$0")
    ./$(basename "$0") apt

EOF
}

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    help
    exit 0
fi

if [ -d "$ROOT/.venv" ]; then
    source $ROOT/.venv/bin/activate
fi

if ! ansible --version > /dev/null 2>&1; then
  echo -e "🚨 ERROR: Cannot perform "ansible --version". Is ansible installed? \n"
  help
  exit 1
fi

if ! molecule --version > /dev/null 2>&1; then
  echo -e "🚨 ERROR: Cannot perform "molecule --version". Is molecule installed? \n"
  help
  exit 1
fi

if ! molecule --version | grep -q docker > /dev/null 2>&1; then
  echo -e "🚨 ERROR: Cannot find "docker" in output of "molecule --version". Are molecule-plugins and the docker driver installed? \n"
  help
  exit 1
fi

if ! docker ps > /dev/null 2>&1; then
  echo -e "🚨 ERROR: Cannot perform "docker ps". Is the docker daemon installed and running? \n"
  help
  exit 1
fi

if [ -z "$1" ]; then
    ROLES_TO_TEST=$(find "$ROOT/roles" -mindepth 1 -maxdepth 1 -type d)
else
    ROLES_TO_TEST="$ROOT/roles/$1"
fi

for role in $ROLES_TO_TEST; do
    cd $role
    if [ -d "molecule" ]; then
        printf "ℹ️  Starting molecule tests for '$(basename $role)' role \n\n" && molecule test;
    else
        printf "⚠️  Cannot find molecule tests for '$(basename $role)' role \n\n" && exit 1
    fi
done
