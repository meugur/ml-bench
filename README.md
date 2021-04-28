# ml-bench

This repository contains scripts to evaluate MLPerf Inference benchmarks.
The benchmarks are run in Docker containers, so the images will need to be built.
There are also instructions for building TensorFlow and PyTorch libraries.

## Config
These scripts set up the testing environment. They are meant for Intel systems.
```
./scripts/setup-env.sh

./scripts/revert-env.sh
```

## Libraries

### TensorFlow

The first step is to build an image for compiling TensorFlow.

Default TensorFlow source code:
```
cd docker && docker build -t meugur/tensorflow:py36 -f Dockerfile.tf.py36 .
```

Custom TensorFlow source code:

The TensorFlow code should be in the `docker/source/tensorflow` relative directory.
```
cd docker && docker build -t meugur/tensorflow:py36-cust-opt -f Dockerfile.tf.py36-custom .
```

After building the image, then run the container using:
```
./scripts/tensorflow-build.sh meugur/tensorflow:py36
```
Then, run the following commands to build the library.
During configuration, you can specify custom flags to the compiler.
```
./configure
bazel build --repo_env=CC=clang --config=opt --subcommands //tensorflow/tools/pip_package:build_pip_package
./bazel-bin/tensorflow/tools/pip_package/build_pip_package /mnt 
chown $HOST_PERMS /mnt/tensorflow-2.4.1-cp36-cp36m-linux_x86_64.whl
```
The wheel package should be in the top level directory of this repository afterwards.
You can then keep these wheels for different builds in a separate directory for later.

### PyTorch

The first step is to build an image for compiling PyTorch.

Default PyTorch source code:
```
cd docker && docker build -t meugur/pytorch:py36 -f Dockerfile.pt.py36 .
```

Custom PyTorch source code:

The TensorFlow code should be in the `docker/source/pytorch` relative directory.
```
cd docker && docker build -t meugur/pytorch:py36-cust-opt -f Dockerfile.pt.py36-custom .
```

After building the image, then run the container using:
```
./scripts/pytorch-build.sh meugur/pytorch:py36
```
Then, run the following commands to build the library.
During configuration, you can specify custom flags to the compiler using the `CMAKE_C_FLAGS` and `CMAKE_CXX_FLAGS` env variables.
```
USE_CUDA=0 CMAKE_ARGS='-DCMAKE_VERBOSE_MAKEFILE=ON' CC=clang CXX=clang++ python3 setup.py bdist_wheel
chown $HOST_PERMS /pytorch/dist/torch-1.8.1-cp36-cp36m-linux_x86_64.whl
mv /pytorch/dist/torch-1.8.1-cp36-cp36m-linux_x86_64.whl /mnt
```
The wheel package should be in the top level directory of this repository afterwards.
You can then keep these wheels for different builds in a separate directory for later.

## MLPerf

Next you can build the MLPerf images.
This expects the models and datasets to be in the `docker/datasets` and `docker/models` directories respectively.

Default libraries from pip:
```
cd docker && docker build -t meugur/mlperf-inference:18.04 -f Dockerfile.18.04 .
```

Custom libraries from the previous wheel packages. You can keep the wheels in a `docker/wheels` directory for simplicity.
```
cd docker && docker build -t meugur/mlperf-inference:18.04 -f Dockerfile.18.04-custom --build-arg TF_WHL_DIR=wheels --build-arg PT_WHL_DIR=wheels .
```

## Experiments

After building the MLPerf images with the specified libraries, you can run specific experiments or create your own.

Examples:

Model names are `resnet50`, `mobilenet`, `ssd-mobilenet`, and `ssd-resnet34`. Backends are `tf` or `pytorch`.
Ideally, you specify a `results` directory for all the experiments and the data should be there.

Single thread experiment based on inference count:
```
./scripts/experiment-single-thread-by-count.sh {output_dir} {count} {backend} {model} {image} {core}

./scripts/experiment-single-thread-by-count.sh results/test-run 1024 tf mobilenet meugur/mlperf-inference:18.04 0
./scripts/experiment-single-thread-by-count.sh results/test-run 10 pytorch resnet50 meugur/mlperf-inference:18.04 1
```

Single thread experiment for ports utilization (Note: the events are hardcoded for Intel Skylake architecture):
```
./scripts/experiment-single-thread-ports-util.sh results/test-run 1024 tf mobilenet meugur/mlperf-inference:18.04 0
```

There are some other scripts similar to these (some of them need to be updated or I left out).
You can also vary different variables for MLPerf based on env variables within the scripts for different experiments.
These include `SCENARIO`, `THREADS`, `DATAFORMAT`, `MAXTIME`, `MAXBATCHSIZE`, `COUNT`, `PERF_FLAGS`, etc.
There are many different possible tests that can be done, so I tried to keep the most relevant ones.

