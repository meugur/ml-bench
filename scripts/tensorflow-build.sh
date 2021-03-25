#!/bin/bash -e

IMAGE="meugur/tensorflow:2.4.1"

# docker pull tensorflow/tensorflow:devel

docker run -it -w /tensorflow_src \
    --cpus 2 \
    -v $PWD:/mnt \
    -e HOST_PERMS="$(id -u):$(id -g)" \
    ${IMAGE} bash

