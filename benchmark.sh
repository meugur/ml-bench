#!/bin/bash 

set -e

CK_REPOS="${HOME}/ml-bench"
CK_IMAGE="mlperf-inference-vision-with-ck.intel.ubuntu-18.04"
CK_IMAGE_W_TAG="ctuning/${CK_IMAGE}:tf-1.15"

REPETITIONS=10
SCENARIO="SingleStream"
MODEL="ssd,mobilenet-v1,fpn"
TAG="ssd-mobilenet-v1-fpn"

docker run --env-file ${CK_REPOS}/ck-mlperf/docker/${CK_IMAGE}/env.list \
    --rm ${CK_IMAGE_W_TAG} \
    "ck run program:mlperf-inference-vision \
    --cmd_key=direct \
    --repetitions=${REPETITIONS} \
    --env.CUDA_VISIBLE_DEVICES=-1 \
    --env.CK_LOADGEN_EXTRA_PARAMS='--count 50' \
    --env.CK_METRIC_TYPE=COCO \
    --env.CK_LOADGEN_SCENARIO=${SCENARIO} \
    --env.CK_LOADGEN_MODE='--accuracy' \
    --dep_add_tags.weights=${MODEL} \
    --dep_add_tags.lib-tensorflow=vcpu \ 
    --env.CK_LOADGEN_BACKED=tensorflow \
    --env.CK_LOADGEN_REF_PROFILE=default_tf_object_det_zoo \
    --skip_print_timers"
