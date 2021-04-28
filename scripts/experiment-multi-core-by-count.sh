#!/bin/bash -e

DEVICE="cpu"
SCENARIO="SingleStream"

OUTPUT_DIR=$1
COUNT=$2
BACKEND=$3
MODEL=$4
IMAGE=$5
RUNS=$6

if [[ -z ${IMAGE} || -z ${RUNS} || -z ${MODEL} || -z ${COUNT} || -z ${BACKEND} || -z ${OUTPUT_DIR} ]]; then
    echo "Usage: $0 output_dir count backend model image runs"
    exit 1
fi

source scripts/revert-env.sh

for i in $( eval echo {1..$RUNS} ); do
    echo 3 | sudo tee /proc/sys/vm/drop_caches && sync
    source scripts/${MODEL}.sh
    eval ${WORKLOAD[@]}
done
