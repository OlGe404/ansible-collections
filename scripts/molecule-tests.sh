#!/bin/bash -e

ROOT=$(git rev-parse --show-toplevel)
ROLES=$(find $ROOT/roles -mindepth 1 -maxdepth 1 -type d)

for role in $ROLES; do
    cd $role
    if [ -d "molecule" ]; then
        printf "ℹ️  Starting molecule tests for '$(basename $role)' role \n\n" && molecule test;
    else
        printf "⚠️  Cannot find molecule tests for '$(basename $role)' role \n\n" && exit 1
    fi
done
