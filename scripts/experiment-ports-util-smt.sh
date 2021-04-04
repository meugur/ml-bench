#!/bin/bash -e

CPU=0
THREADS=2
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
source scripts/setup-perf-env.sh
for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo performance | sudo tee $i
done
echo 1 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
echo 3 | sudo tee /proc/sys/vm/drop_caches && sync

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
