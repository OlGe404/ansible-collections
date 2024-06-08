#!/bin/bash -xe

DOCKERFILE=$1
TIMESTAMP=$(date +%Y%m%d%H%M%S)
IMAGE_TAG="$(basename $DOCKERFILE | cut -d . -f2-)-$TIMESTAMP"
IMAGE_REPO=${2:-docker.io/olge404/molecule}

podman build --file $DOCKERFILE --tag docker.io/olge404/molecule:$IMAGE_TAG .
podman push $IMAGE_REPO:$IMAGE_TAG
