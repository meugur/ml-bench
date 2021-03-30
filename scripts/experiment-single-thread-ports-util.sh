#!/bin/bash -e

CPU=0
THREADS=1
DEVICE="cpu"
MODELS=(
    'resnet50'
    'mobilenet'
    'ssd-mobilenet'
    'ssd-resnet34'
)
IMAGE=${1:-}
OUTPUT_DIR=${2:-}
BACKEND=${3:-"tf"}

if [[ -z ${IMAGE} || -z ${OUTPUT_DIR} ]]; then
    echo "Usage: $0 image output"
    exit 1
fi

# Setup benchmarking environment
source scripts/setup-env.sh

for MODEL in "${MODELS[@]}"; do
    source scripts/${MODEL}.sh ${BACKEND} SingleStream
    PERF_OUTPUT_DIR=${OUTPUT_DIR}/${TAG}
    mkdir -p ${PERF_OUTPUT_DIR}
    source scripts/ports_util.sh
done

for MODEL in "${MODELS[@]}"; do
    source scripts/${MODEL}.sh ${BACKEND} MultiStream
    PERF_OUTPUT_DIR=${OUTPUT_DIR}/${TAG}
    mkdir -p ${PERF_OUTPUT_DIR}
    source scripts/ports_util.sh
done

source scripts/revert-env.sh
