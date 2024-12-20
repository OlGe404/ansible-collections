#!/bin/bash -e

help() {
    cat <<EOF
Usage: ./$(basename $0)
Prerequisites: The docker daemon has to be installed and running.

Description:
  Build, tag and push a container image for each Dockerfile found in the ".molecule/platforms" dir.

  Container images are pushed to "docker.io/olge404/molecule" on dockerhub and tagged with the
  suffix of the Dockerfile + the timestamp of the build, e.g. "debian-12-20241219162345" for
  "Dockerfile.debian-12" or "ubuntu-22.04-20241219162424" for "Dockerfile.ubuntu-22.04".

  Login to dockerhub is not handled by this script and has to be performed seperately in advance.

Options:
  -h, --help    Show this help message and exit.

EOF
}

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    help
    exit 0
fi

if !docker ps > /dev/null 2>&1; then
  echo -e "🚨 ERROR: Cannot perform "docker ps". Is the docker daemon installed and running? \n"
  help
fi

DOCKERFILES=$(find "$(git rev-parse --show-toplevel)/.molecule/platforms" -name "Dockerfile.*")

for dockerfile in $DOCKERFILES; do
    TIMESTAMP=$(date +%Y%m%d%H%M%S)
    IMAGE_TAG="$(basename $dockerfile | cut -d . -f2-)-$TIMESTAMP"

    docker build --file $dockerfile --tag docker.io/olge404/molecule:$IMAGE_TAG .
    docker push docker.io/olge404/molecule:$IMAGE_TAG

    echo -e "✅ Successfully pushed docker.io/olge404/molecule:$IMAGE_TAG to dockerhub \n"
done
