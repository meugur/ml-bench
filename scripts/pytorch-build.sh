#!/bin/bash -e

IMAGE=${1:-"meugur/pytorch:1.8-py36"}

docker run -it --rm \
    -v $PWD:/mnt \
    -e HOST_PERMS="$(id -u):$(id -g)" \
    -e VERBOSE=1 \
    -e CMAKE_ARGS='-DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_TOOLCHAIN_PREFIX=llvm-' \
    -e USE_CUDA=0 \
    -e CC=clang \
    -e CXX=clang++ \
    -e PYTORCH_BUILD_VERSION=1.8.1 \
    -e PYTORCH_BUILD_NUMBER=1 \
    ${IMAGE} bash

    # -e CMAKE_C_FLAGS='-fno-vectorize -fno-slp-vectorize' \
    # -e CMAKE_CXX_FLAGS='-fno-vectorize -fno-slp-vectorize' \
    # -e CMAKE_C_FLAGS='-Rpass=loop-vectorize -Rpass-missed=loop-vectorize -Rpass-analysis=loop-vectorize' \
    # -e CMAKE_CXX_FLAGS='-Rpass=loop-vectorize -Rpass-missed=loop-vectorize -Rpass-analysis=loop-vectorize' \
    # --cpus 10 \
    # USE_CUDA=0 CC=clang CFLAGS= python3 setup.py bdist_wheel
    # -e CMAKE_ARGS='-DCMAKE_VERBOSE_MAKEFILE=ON'
    # chown $HOST_PERMS /pytorch/dist/
    # mv /pytorch/dist/* /mnt

