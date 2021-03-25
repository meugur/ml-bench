#!/bin/bash 

set -e

DEVICE="cpu"
MODEL="resnet50"
IMAGE="meugur/mlperf-inference:18.04"

# Configurations
CPU=0
BACKEND=${1:-"tf"}
SCENARIO=${2:-"SingleStream"}
DATASET="/root/datasets/imagenet"
DATAFORMAT="NHWC" # NCHW or NHWC
MAXBATCHSIZE=128
THREADS=1
MAXTIME=120
COUNT=1024
INTERVAL=100

TAG="${MODEL}-${BACKEND}-${DEVICE}-${SCENARIO}"

WORKLOAD=(
    'docker run --rm -it'
    "--cpuset-cpus ${CPU}"
    "-e DATA_DIR=${DATASET}"
    '-e MODEL_DIR=/root/models'
    "${IMAGE}"
    'bash'
    'run_local.sh'
    "${BACKEND} ${MODEL} ${DEVICE}"
    "--data-format ${DATAFORMAT}"
    "--time ${MAXTIME}"
    "--scenario ${SCENARIO}"
    "--threads ${THREADS}"
    "--count ${COUNT}"
    "--max-batchsize ${MAXBATCHSIZE}"
)

if [[ ${BACKEND} == "pytorch" ]]; then
    WORKLOAD=(
        'docker run --rm -it'
        "--cpuset-cpus ${CPU}"
        "-e DATA_DIR=${DATASET}"
        '-e MODEL_DIR=/root/models'
        "${IMAGE}"
        'bash'
        'run_local.sh'
        "${BACKEND} ${MODEL} ${DEVICE}"
        "--time ${MAXTIME}"
        "--scenario ${SCENARIO}"
        "--threads ${THREADS}"
        "--count ${COUNT}"
        "--max-batchsize ${MAXBATCHSIZE}"
    )
fi

PERF_OUTPUT_DIR="$(pwd)/perf-output-no-multiplex-18.04"
mkdir -p ${PERF_OUTPUT_DIR}/${TAG}

# source scripts/setup-env.sh
# source scripts/toplev.sh l1
# source scripts/toplev.sh l2
source scripts/toplev.sh l3
# source scripts/revert-env.sh
