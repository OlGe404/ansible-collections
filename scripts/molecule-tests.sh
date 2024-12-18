#!/bin/bash -e

ROOT=$(git rev-parse --show-toplevel)

# Test all roles found in the "roles/" dir, if role is not provided as $1
if [ -z "$1" ]; then
    ROLES_TO_TEST=$(find "$ROOT/roles" -mindepth 1 -maxdepth 1 -type d)
else
    ROLES_TO_TEST="$ROOT/roles/$1"
fi

if [ -d "$ROOT/.venv" ]; then
    source $ROOT/.venv/bin/activate
fi

for role in $ROLES_TO_TEST; do
    cd $role
    if [ -d "molecule" ]; then
        printf "ℹ️  Starting molecule tests for '$(basename $role)' role \n\n" && molecule test;
    else
        printf "⚠️  Cannot find molecule tests for '$(basename $role)' role \n\n" && exit 1
    fi
done
