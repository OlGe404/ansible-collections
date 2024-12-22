#!/bin/bash -e

ROOT=$(git rev-parse --show-toplevel)

help() {
    cat <<EOF
Usage: ./$(basename $0)
Prerequisites: The python3-venv package has to be installed. Run "sudo apt install python3-venv -y" to do so (on debian like distros).

Description:
    This script creates a virtual environment for python3 at "$ROOT/.venv" and installs all pip packages
    from the "$ROOT/requirements.txt" file in it.

Options:
  -h, --help    Show this help message and exit.

EOF
}

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    help
    exit 0
fi

if !python3 -m venv --help > /dev/null 2>&1; then
  echo -e "🚨 ERROR: Cannot perform "python3 -m venv --help". Is the python3-venv package installed? \n"
  help
  exit 1
fi

python3 -m venv $ROOT/.venv && source $ROOT/.venv/bin/activate
pip install --upgrade --quiet pip setuptools wheel
pip install --upgrade --quiet --requirement "$ROOT/requirements.txt"
echo -e "✅ Successfully installed pip packages:\n$(pip freeze)"
