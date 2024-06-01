#!/bin/bash

DOCKERFILE=$1
TIMESTAMP=$(date +%Y%m%d%H%M%S)
IMAGE_TAG="$(basename $DOCKERFILE | cut -d . -f2-)-$TIMESTAMP"

podman build --file $DOCKERFILE --tag docker.io/olge404/molecule:$IMAGE_TAG .
podman push docker.io/olge404/molecule:$IMAGE_TAG
