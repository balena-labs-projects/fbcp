#!/bin/bash
set -e

function build_and_push_image () {

  echo "Building for dtoverlay displays, pushing to $DOCKER_REPO/$REPO_NAME:dtoverlay"

  docker buildx build --load -t $DOCKER_REPO/$REPO_NAME:dtoverlay --platform $DOCKER_ARCH --file Dockerfile.dtoverlay .

  echo "Publishing..."
  docker push $DOCKER_REPO/$REPO_NAME:dtoverlay

}

# YOu can pass in a repo (such as a test docker repo) or accept the default
DOCKER_REPO=${1:-balenablocks}
REPO_NAME="fbcp"
DOCKER_ARCH="linux/arm/v7"

build_and_push_image 
