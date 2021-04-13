#!/bin/bash -e

IMAGE=$1

docker run --rm -it \
    -v $(pwd)/results:/root/results \
    --privileged \
    "${IMAGE}"
    bash

