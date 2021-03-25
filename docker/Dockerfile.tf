FROM tensorflow/tensorflow:devel

LABEL maintainer="Muhammed Ugur <meugur@umich.edu>"

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y clang
RUN apt clean

RUN cd /tensorflow_src && git checkout v2.4.1

RUN cd "/usr/local/lib/bazel/bin/" && \
    curl -fLO https://releases.bazel.build/3.1.0/release/bazel-3.1.0-linux-x86_64 && \
    chmod +x bazel-3.1.0-linux-x86_64

WORKDIR /tensorflow_src
