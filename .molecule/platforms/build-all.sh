#!/bin/bash -xe

ROOT=$(git rev-parse --show-toplevel)
DOCKERFILES=$(find "$ROOT/.molecule/platforms" -name "Dockerfile.*")

for dockerfile in $DOCKERFILES; do
    TIMESTAMP=$(date +%Y%m%d%H%M%S)
    IMAGE_TAG="$(basename $dockerfile | cut -d . -f2-)-$TIMESTAMP"

    docker build --file $dockerfile --tag docker.io/olge404/molecule:$IMAGE_TAG .
    docker push docker.io/olge404/molecule:$IMAGE_TAG
done
