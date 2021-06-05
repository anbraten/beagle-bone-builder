#!/bin/bash

if [ -z "$CI" ]; then
  echo "Not in CI => running ./setup.sh before continuing"
  ./setup.sh
fi

CMD="${1:-build-all}"

echo "Executing /lfs/scripts/$CMD.sh ..."

DOCKER_ARGS="--rm --privileged"
if [ -t 0 ] ; then
  DOCKER_ARGS="-it --rm --privileged "
fi

docker run $DOCKER_ARGS \
  -v $(pwd)/output:/lfs/output \
  -v $(pwd)/resources:/lfs/resources \
  -v $(pwd)/tmp:/lfs/tmp \
  image-builder /lfs/scripts/$CMD.sh
