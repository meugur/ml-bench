#!/bin/bash -e

IMAGE="meugur/tensorflow:2.4.1-py36-cust-opt"

docker run -it --rm \
    --cpus="10" \
    -v $PWD:/mnt \
    -e HOST_PERMS="$(id -u):$(id -g)" \
    ${IMAGE} bash
    # ./configure
    # bazel build --repo_env=CC=clang --config=opt --subcommands //tensorflow/tools/pip_package:build_pip_package
    # ./bazel-bin/tensorflow/toosl/pip_package/build_pip_package /mnt 
    # chown $HOST_PERMS /mnt/tensorflow-2.4.1-cp36-cp36m-linux_x86_64.whl


