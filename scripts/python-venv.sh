#!/bin/bash -e

ROOT=$(git rev-parse --show-toplevel)

python3 -m venv $ROOT/.venv && source $ROOT/.venv/bin/activate
pip install --upgrade pip setuptools wheel
pip install --upgrade -r requirements.txt
