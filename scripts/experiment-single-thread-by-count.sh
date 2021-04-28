#!/bin/bash -e

THREADS=1
DEVICE="cpu"
SCENARIO="SingleStream"

OUTPUT_DIR=$1
COUNT=$2
BACKEND=$3
MODEL=$4
IMAGE=$5
CPU=$6

if [[ -z ${IMAGE} || -z ${CPU} || -z ${COUNT} || -z ${MODEL} || -z ${BACKEND}  || -z ${OUTPUT_DIR} ]]; then
    echo "Usage: $0 output_dir count backend model image cpu"
    exit 1
fi


# source scripts/setup-env.sh

IMAGE="meugur/mlperf-inference:18.04-full-opt"
source scripts/${MODEL}.sh
eval ${WORKLOAD[@]}

IMAGE="meugur/mlperf-inference:18.04-no-vec"
source scripts/${MODEL}.sh
eval ${WORKLOAD[@]}

IMAGE="meugur/mlperf-inference:18.04-cust-opt"
source scripts/${MODEL}.sh
eval ${WORKLOAD[@]}

# source scripts/revert-env.sh
