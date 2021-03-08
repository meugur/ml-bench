FROM ubuntu:20.04

LABEL maintainer="Muhammed Ugur <meugur@umich.edu>"

SHELL ["/bin/bash", "-c"]

ENV PYTHON_VERSION=3.7
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PATH /opt/anaconda3/bin:$PATH
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt-get install -y \
      git \
      build-essential \
      software-properties-common \
      ca-certificates \
      wget \
      curl \
      zip \
      unzip
RUN apt clean

RUN cd /opt && \
    wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh -O miniconda.sh && \
    /bin/bash ./miniconda.sh -b -p /opt/anaconda3 && \
    rm miniconda.sh && \
    /opt/anaconda3/bin/conda clean -tipsy && \
    ln -s /opt/anaconda3/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/anaconda3/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    conda config --set always_yes yes --set changeps1 no

RUN conda install pytorch-cpu torchvision-cpu -c pytorch
RUN pip install \
    future \
    pillow \
    onnx \
    opencv-python-headless \
    tensorflow \
    onnxruntime \
    Cython \
    pycocotools \
    pybind11

RUN cd /root && git clone --recursive https://github.com/mlcommons/inference && \
    cd /root/inference/loadgen && \
    CFLAGS="-std=c++14" python setup.py install

ADD ["datasets/*", "/root/datasets/"]
ADD ["models/*", "/root/models/"]

WORKDIR /root/inference/vision/classification_and_detection
