#!/bin/bash
set -e

function build_and_push_image () {
  local DISPLAY=$1
  local TARGET=$2

  echo "Building for display $DISPLAY, pushing to $DOCKER_REPO/$REPO_NAME:$DISPLAY"

  docker buildx build --build-arg TARGET=$TARGET -t $DOCKER_REPO/$REPO_NAME:$DISPLAY --platform $DOCKER_ARCH .

  echo "Publishing..."
  docker push $DOCKER_REPO/$REPO_NAME:$DISPLAY

}

# YOu can pass in a repo (such as a test docker repo) or accept the default
DOCKER_REPO=${1:-balenablocks}
REPO_NAME="fbcp"
DOCKER_ARCH="linux/arm/v7"

# dirs=$(ls -d */)
# echo $dirs
# for display_dir in $dirs; do
#     display=$(basename $display_dir)
#     echo $display
#     build_and_push_image $display
# done

# displays="adafruit-ili9341-pitft"
displays="adafruit-hx8357d-pitft adafruit-ili9341-pitft freeplaytech-waveshare32b waveshare35b-ili9486 tontec-mz61581 waveshare-st7789vw-hat waveshare-st7735s-hat kedei-v63-mpi3501"

for display in $displays;do

  target=$( echo $display | tr - _ | tr [:lower:] [:upper:])
  build_and_push_image $display $target
done