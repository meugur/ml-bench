#!/bin/bash -e

IMAGE="meugur/pytorch:1.8-py36-cust-opt"

docker run -it --rm \
    --cpus 10 \
    -v $PWD:/mnt \
    -e HOST_PERMS="$(id -u):$(id -g)" \
    -e VERBOSE=1 \
    -e CMAKE_ARGS='-DCMAKE_VERBOSE_MAKEFILE=ON' \
    -e USE_CUDA=0 \
    -e CMAKE_C_FLAGS='-Rpass=loop-vectorize -Rpass-missed=loop-vectorize -Rpass-analysis=loop-vectorize' \
    -e CMAKE_CXX_FLAGS='-Rpass=loop-vectorize -Rpass-missed=loop-vectorize -Rpass-analysis=loop-vectorize' \
    -e CC=clang \
    -e CXX=clang++ \
    -e PYTORCH_BUILD_VERSION=1.8.1 \
    -e PYTORCH_BUILD_NUMBER=1 \
    ${IMAGE} bash

    # USE_CUDA=0 CC=clang CFLAGS= python3 setup.py bdist_wheel
    # -e CMAKE_ARGS='-DCMAKE_VERBOSE_MAKEFILE=ON'
    # chown $HOST_PERMS /pytorch/dist/
    # mv /pytorch/dist/* /mnt

