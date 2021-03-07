#!/bin/bash 

set -e

PERF=/usr/bin/perf

CK_REPOS="${HOME}/ml-bench"
CK_IMAGE="mlperf-inference-vision-with-ck.intel.ubuntu-18.04"
CK_IMAGE_W_TAG="ctuning/${CK_IMAGE}:tf-1.15"
CK_EXPERIMENTS_DIR="$(pwd)/mlperf-inference-vision-results"
PERF_OUTPUT_DIR="$(pwd)/mlperf-inference-vision-perf-output"

mkdir -p ${CK_EXPERIMENTS_DIR}
mkdir -p ${PERF_OUTPUT_DIR}

CPU=0
RUNS=1
REPETITIONS=1
SCENARIO="SingleStream"
MODEL="ssd,mobilenet-v1,fpn"
TAG="ssd-mobilenet-v1-fpn"

sudo $PERF stat -o "${PERF_OUTPUT_DIR}/${TAG}.log" \
    -e cycles,cycles:k,instructions,instructions:k -C ${CPU} -r ${RUNS} -- \
    docker run --env-file ${CK_REPOS}/ck-mlperf/docker/${CK_IMAGE}/env.list \
    --user=$(id -u):1500 --volume ${CK_EXPERIMENTS_DIR}:/home/dvdt/CK_REPOS/local/experiment \
    --rm ${CK_IMAGE_W_TAG} \
    "ck benchmark program:mlperf-inference-vision \
    --cmd_key=direct \
    --repetitions=${REPETITIONS} \
    --env.CUDA_VISIBLE_DEVICES=-1 \
    --env.CK_LOADGEN_EXTRA_PARAMS='--count 50' \
    --env.CK_METRIC_TYPE=COCO \
    --env.CK_LOADGEN_SCENARIO=${SCENARIO} \
    --env.CK_LOADGEN_MODE='--accuracy' \
    --dep_add_tags.weights=${MODEL} \
    --dep_add_tags.lib-tensorflow=vcpu \
    --env.CK_LOADGEN_BACKEND=tensorflow \
    --env.CK_LOADGEN_REF_PROFILE=default_tf_object_det_zoo \
    --record \
    --record_repo=local \
    --record_uoa=mlperf.open.object-detection.cpu.${TAG}.singlestream.accuracy \
    --tags=mlperf,open,object-detection,cpu,${TAG},singlestream,accuracy \
    --skip_print_timers \
    --skip_stat_analysis \
    --process_multi_keys"

