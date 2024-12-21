#!/bin/bash -e

ROOT="$(git rev-parse --show-toplevel)"

help() {
    cat <<EOF
Usage: ./$(basename "$0") [DOCKERFILE]
Prerequisites: The docker daemon has to be installed and running.

Description:
  Build, tag and push a container image for each Dockerfile found in the "$ROOT/.molecule/platforms" dir,
  if no DOCKERFILE arg is provided. The "$ROOT/.molecule/platforms" dir is always used as build context.

  Container images are pushed to "docker.io/olge404/molecule" on dockerhub and tagged with the
  suffix of the Dockerfile + the timestamp of the build, e.g. "debian-12-20241219162345" for
  "Dockerfile.debian-12" or "ubuntu-22.04-20241219162424" for "Dockerfile.ubuntu-22.04".

  Login to dockerhub is not handled by this script and has to be performed seperately in advance.

Arguments:
  DOCKERFILE    Path to a Dockerfile to use for the container image build (optional).
                NOTE: The filename has to match ".*Dockerfile.*".

Options:
  -h, --help    Show this help message and exit.

Examples:
  ./$(basename "$0")
  ./$(basename "$0") .molecule/platforms/Dockerfile.debian-12

EOF
}

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    help
    exit 0
fi

if ! docker ps > /dev/null 2>&1; then
  echo -e "🚨 ERROR: Cannot perform "docker ps". Is the docker daemon installed and running? \n"
  help
fi

if [ -n "$1" ]; then
    if [ -f "$1" ]; then
        DOCKERFILES="$1"
    else
        echo -e "🚨 ERROR: Dockerfile \"$1\" cannot be found. Exiting. \n"
        exit 1
    fi
else
    DOCKERFILES=$(find "$ROOT/.molecule/platforms" -name "Dockerfile.*")
fi

for dockerfile in $DOCKERFILES; do
    TIMESTAMP=$(date +%Y%m%d%H%M%S)
    IMAGE_TAG="$(basename "$dockerfile" | cut -d . -f2-)-$TIMESTAMP"

    docker buildx build --file "$dockerfile" --tag "docker.io/olge404/molecule:$IMAGE_TAG" "$ROOT/.molecule/platforms"
    docker push "docker.io/olge404/molecule:$IMAGE_TAG"

    echo -e "✅ Successfully pushed 'docker.io/olge404/molecule:$IMAGE_TAG' to dockerhub \n"
done
