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
OUTPUT_DIR=$1
COUNT=$2
BACKEND=$3
IMAGE=$4
MAXTIME=600

if [[ -z ${IMAGE} || -z ${OUTPUT_DIR} ]]; then
    echo "Usage: $0 output_dir count backend image"
    exit 1
fi

source scripts/setup-env.sh

SCENARIO="SingleStream"
for MODEL in "${MODELS[@]}"; do
    source scripts/${MODEL}.sh
    eval ${WORKLOAD[@]}
done

SCENARIO="MultiStream"
for MODEL in "${MODELS[@]}"; do
    source scripts/${MODEL}.sh
    eval ${WORKLOAD[@]}
done

source scripts/revert-env.sh
