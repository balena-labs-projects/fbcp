#!/bin/bash
set -e

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

DOCKER_REPO=${1:-balenablocks}
REPO_NAME="fbcp"
VERSION="$(<VERSION)"

echo "building $DOCKER_REPO/$REPO_NAME:$VERSION..."
docker build . \
    --tag "$DOCKER_REPO/$REPO_NAME:$VERSION" \
    --tag "$DOCKER_REPO/$REPO_NAME:latest"
