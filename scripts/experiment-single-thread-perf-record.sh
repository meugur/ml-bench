#!/bin/bash -e

CPU=0
THREADS=1
DEVICE="cpu"

OUTPUT_DIR=${1:-}
COUNT=${2:-8192}
BACKEND=${3:-"tf"}
IMAGE=${4:-"meugur/mlperf-inference:18.04"}
MAXTIME=600

MODELS=(
    'resnet50'
    'mobilenet'
    'ssd-mobilenet'
    'ssd-resnet34'
)

if [[ -z ${OUTPUT_DIR} ]]; then
    echo "Usage: $0 output"
    exit 1
fi

source scripts/setup-env.sh

SCENARIO="SingleStream"
PERF_FLAGS=("-C ${CPU}" '-g' '-e r2a6,r4a6,r8a6,r10a6')
for MODEL in "${MODELS[@]}"; do
    source scripts/${MODEL}.sh
    eval ${WORKLOAD[@]}
done

# SCENARIO="SingleStream"
# IMAGE="meugur/mlperf-inference:18.04-full-opt"
# PERF_FLAGS=("-C ${CPU}" "-g" '-e r2a6,r4a6,r8a6,r10a6')
# for MODEL in "${MODELS[@]}"; do
#     source scripts/${MODEL}.sh
#     eval ${WORKLOAD[@]}
# done

# SCENARIO="SingleStream"
#IMAGE="meugur/mlperf-inference:18.04-no-vec"
#PERF_FLAGS=("-C ${CPU}" "-g" '-e r2a6,r4a6,r8a6,r10a6')
#for MODEL in "${MODELS[@]}"; do
#    source scripts/${MODEL}.sh
#    eval ${WORKLOAD[@]}
#done

#SCENARIO="MultiStream"
#IMAGE="meugur/mlperf-inference:18.04"
#PERF_FLAGS=("-C ${CPU}" "-g" '-e r2a6,r4a6,r8a6,r10a6')
#for MODEL in "${MODELS[@]}"; do
#    source scripts/${MODEL}.sh
#    eval ${WORKLOAD[@]}
#done

#SCENARIO="MultiStream"
#IMAGE="meugur/mlperf-inference:18.04-full-opt"
#PERF_FLAGS=("-C ${CPU}" "-g" '-e r2a6,r4a6,r8a6,r10a6')
#for MODEL in "${MODELS[@]}"; do
#    source scripts/${MODEL}.sh
#    eval ${WORKLOAD[@]}
#done

#SCENARIO="MultiStream"
#IMAGE="meugur/mlperf-inference:18.04-no-vec"
#PERF_FLAGS=("-C ${CPU}" "-g" '-e r2a6,r4a6,r8a6,r10a6')
#for MODEL in "${MODELS[@]}"; do
#    source scripts/${MODEL}.sh
#    eval ${WORKLOAD[@]}
#done

#CPU=""
# THREADS=""
# PERF_FLAGS=('-a' '-e r2a6,r4a6,r8a6,r10a6')
# source scripts/mobilenet.sh
# eval ${WORKLOAD[@]}

source scripts/revert-env.sh
