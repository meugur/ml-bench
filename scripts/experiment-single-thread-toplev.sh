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

source scripts/setup-env.sh
source scripts/${MODEL}.sh
source scripts/toplev.sh l3
source scripts/revert-env.sh

