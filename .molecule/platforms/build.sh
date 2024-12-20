#!/bin/bash -e

help() {
    cat <<EOF
Usage: ./$(basename $0) <DOCKERFILE>
Prerequisites: The docker daemon has to be installed and running.

Description:
  Build, tag and push a container image for the Dockerfile provided.

  The container image is pushed to "docker.io/olge404/molecule" on dockerhub and tagged with the
  suffix of the Dockerfile + the timestamp of the build, e.g. "debian-12-20241219162345" for
  "Dockerfile.debian-12" or "ubuntu-22.04-20241219162424" for "Dockerfile.ubuntu-22.04".

  Login to dockerhub is not handled by this script and has to be performed seperately in advance.

Arguments:
    DOCKERFILE      Path of the Dockerfile to use.

Options:
  -h, --help    Show this help message and exit.

Example:
    ./$(basename $0) Dockerfile.alpine-3.20

EOF
}

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    help
    exit 0
fi

if [ "$#" -ne 1 ]; then
    echo -e "🚨 ERROR: The 'DOCKERFILE' argument is mandatory. \n"
    help
    exit 1
fi

if !docker ps > /dev/null 2>&1; then
  echo -e "🚨 ERROR: Cannot perform "docker ps". Is the docker daemon installed and running? \n"
  help
  exit 1
fi

DOCKERFILE=$1
TIMESTAMP=$(date +%Y%m%d%H%M%S)
IMAGE_TAG="$(basename $DOCKERFILE | cut -d . -f2-)-$TIMESTAMP"

docker build --file $DOCKERFILE --tag docker.io/olge404/molecule:$IMAGE_TAG .
docker push docker.io/olge404/molecule:$IMAGE_TAG
echo -e "✅ Successfully pushed docker.io/olge404/molecule:$IMAGE_TAG to dockerhub \n"
