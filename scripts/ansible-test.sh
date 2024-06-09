#!/bin/bash -e

ROOT=$(git rev-parse --show-toplevel)
TMP="/tmp/ansible_collections"

if [ -d "$ROOT/.venv" ]; then
    source $ROOT/.venv/bin/activate
fi

ansible-galaxy collection install --force $ROOT -p $TMP
cd $TMP/olge404/unix && ansible-test sanity && rm -rf $TMP
