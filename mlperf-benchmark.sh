#!/bin/bash 

set -e

PERF=/usr/bin/perf

CPU=0
RUNS=5
BACKEND="tf"
MODEL="resnet50"
DEVICE="cpu"
SCENARIO="SingleStream"
THREADS=1
MAXTIME=100
COUNT=10
INTERVAL=100
TAG="${MODEL}-${BACKEND}-${DEVICE}-${SCENARIO}"
PERF_OUTPUT_DIR="$(pwd)/perf-output"

mkdir -p ${PERF_OUTPUT_DIR}/${TAG}

WORKLOAD=(
    'docker run --rm -it'
    "--cpuset-cpus ${CPU}"
    "--volume $(pwd)/reports:/root/inference/v0.5/classification_and_detection/output"
    '-e DATA_DIR=/root/datasets/imagenet'
    '-e MODEL_DIR=/root/models'
    'nexgus/mlperf-inference:v0.5'
    'bash'
    'run_local.sh'
    "${BACKEND} ${MODEL} ${DEVICE}"
    "--time ${MAXTIME} --scenario ${SCENARIO} --threads ${THREADS} --count ${COUNT}"
)

# Setup benchmarking environment
echo 1 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
do
    echo performance | sudo tee $1
done
echo 0 | sudo tee /proc/sys/kernel/nmi_watchdog
echo -1 | sudo tee /proc/sys/kernel/perf_event_paranoid
echo off | sudo tee /sys/devices/system/cpu/smt/control
echo 3 | sudo tee /proc/sys/vm/drop_caches && sync

$PERF stat -o "${PERF_OUTPUT_DIR}/${TAG}/perf-cycles-instr.log" \
   -e cycles,cycles:k,instructions,instructions:k \
   -C ${CPU} \
   -r ${RUNS} \
   -- ${WORKLOAD[@]}

$PERF stat -o "${PERF_OUTPUT_DIR}/${TAG}/perf-icache-itlb.log" \
   -e L1-icache-load-misses,L1-icache-load-misses:k,iTLB-load-misses,iTLB-load-misses:k \
   -C ${CPU} \
   -r ${RUNS} \
   -- ${WORKLOAD[@]}

$(pwd)/pmu-tools/toplev.py \
    -l1 \
    -C${CPU} \
    -v \
    --no-desc \
    --single-thread \
    -x, \
    -o "${PERF_OUTPUT_DIR}/${TAG}/toplev.csv" \
    -- ${WORKLOAD[@]}

$(pwd)/pmu-tools/toplev.py \
    -l1 \
    -C${CPU} \
    -v \
    --no-desc \
    --single-thread \
    -I ${INTERVAL} \
    --graph \
    --graph-cpu C${CPU}-T${CPU} \
    --title ${TAG} \
    -o "${PERF_OUTPUT_DIR}/${TAG}/plot.png" \
    -- ${WORKLOAD[@]}

# Revert benchmarking environment
for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
do
    echo powersave | sudo tee $1
done
echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
echo 1 | sudo tee /proc/sys/kernel/nmi_watchdog
echo 4 | sudo tee /proc/sys/kernel/perf_event_paranoid
echo on | sudo tee /sys/devices/system/cpu/smt/control

