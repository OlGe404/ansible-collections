#!/bin/bash -e

ROOT=$(git rev-parse --show-toplevel)
TMP="/tmp/ansible_collections"

ansible-galaxy collection install --force $(git rev-parse --show-toplevel) -p $TMP
cd $TMP/olge404/unix && ansible-test sanity && rm -rf $TMP
