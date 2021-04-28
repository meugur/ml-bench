#!/bin/bash -e

IMAGE=$1

docker run -it --rm \
    -v $PWD:/mnt \
    -e HOST_PERMS="$(id -u):$(id -g)" \
    -e VERBOSE=1 \
    -e CC=clang \
    -e CXX=clang++ \
    ${IMAGE} bash

