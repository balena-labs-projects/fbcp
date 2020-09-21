#!/bin/bash
set -e

function build_and_push_image () {

  echo "Building for ALL displays, pushing to $DOCKER_REPO/$REPO_NAME"

  docker buildx build  -t $DOCKER_REPO/$REPO_NAME --platform $DOCKER_ARCH --file Dockerfile.all .

  echo "Publishing..."
  docker push $DOCKER_REPO/$REPO_NAME:latest

}

# YOu can pass in a repo (such as a test docker repo) or accept the default
DOCKER_REPO=${1:-balenablocks}
REPO_NAME="fbcp"
DOCKER_ARCH="linux/arm/v7"


# displays="adafruit-hx8357d-pitft adafruit-ili9341-pitft freeplaytech-waveshare32b waveshare35b-ili9486 tontec-mz61581 waveshare-st7789vw-hat waveshare-st7735s-hat kedei-v63-mpi3501"


build_and_push_image 
