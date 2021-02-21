#!/bin/bash
set -e

DOCKER_REPO=${1:-balenablocks}
REPO_NAME="fbcp"
VERSION="$(<VERSION)"

./build.sh "${DOCKER_REPO}"

echo "pushing $DOCKER_REPO/$REPO_NAME:$VERSION..."
docker push "$DOCKER_REPO/$REPO_NAME:$VERSION"

echo "pushing $DOCKER_REPO/$REPO_NAME:latest..."
docker push "$DOCKER_REPO/$REPO_NAME:latest"
