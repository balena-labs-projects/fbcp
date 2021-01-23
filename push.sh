#!/bin/bash
set -e

set +a
# shellcheck disable=SC1091
source build.sh
set -a

for display in $DISPLAYS
do
    echo "pushing $DOCKER_REPO/$REPO_NAME:$display..."
    docker push "$DOCKER_REPO/$REPO_NAME:$display"
done

echo "pushing $DOCKER_REPO/$REPO_NAME:latest..."
docker push "$DOCKER_REPO/$REPO_NAME:latest"
