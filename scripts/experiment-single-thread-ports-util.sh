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

if [[ -z ${IMAGE} || -z ${CPU} || -z ${COUNT} || -z ${MODEL} || -z ${BACKEND} || -z ${OUTPUT_DIR} ]]; then
    echo "Usage: $0 output_dir count backend model image cpu"
    exit 1
fi

PERF_FLAGS=(
    "stat"
    "-C ${CPU}"
    '-e r1a6,r2a6,r4a6,r8a6,r10a6'
    '-r 10'
)
PERF_OUTPUT="ports_util.log"

source scripts/setup-env.sh
source scripts/${MODEL}.sh
eval ${WORKLOAD[@]}
source scripts/revert-env.sh
