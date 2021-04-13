#!/bin/bash -e

IMAGE="meugur/opencv:4.5.1-py38"

docker run -it --rm \
    --cpus 2 \
    -v $PWD:/mnt \
    -e HOST_PERMS="$(id -u):$(id -g)" \
    ${IMAGE} bash

    # -e VERBOSE=1
    # -e ENABLE_HEADLESS=1
    # -e CMAKE_ARGS='-DCMAKE_VERBOSE_MAKEFILE=ON'
    # python3 setup.py bdist_wheel 
    # chown $HOST_PERMS /opencv-python/dist/opencv_python-4.5.1.48-cp38-cp38-linux_x86_64.whl
    # mv /opencv-python/dist/opencv_python-4.5.1.48-cp38-cp38-linux_x86_64.whl /mnt

