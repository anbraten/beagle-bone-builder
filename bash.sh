#!/bin/bash

./setup.sh

DOCKER_ARGS="-it --rm --privileged"

docker run $DOCKER_ARGS \
  -v $(pwd)/output:/lfs/output \
  -v $(pwd)/resources:/lfs/resources \
  -v $(pwd)/tmp:/lfs/tmp \
  image-builder bash
