#!/bin/bash -e

docker pull tensorflow/tensorflow:2.4.1

docker run -it -w /tensorflow_src \
    -v $PWD:/mnt \
    -e HOST_PERMS="$(id -u):$(id -g)" \
    tensorflow/tensorflow:devel bash

