#!/bin/bash 

set -e

MODEL="resnet50"

# Configurations
BACKEND=${1:-"tf"}
SCENARIO=${2:-"SingleStream"}
DATASET="/root/datasets/imagenet"
DATAFORMAT="NHWC" # NCHW or NHWC
MAXBATCHSIZE=128
MAXTIME=120
COUNT=1024

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
