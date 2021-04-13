#!/bin/bash 

set -e

MODEL="resnet50"
BACKEND=${BACKEND:-"tf"}
SCENARIO=${SCENARIO:-"SingleStream"}
DATASET="/root/datasets/imagenet"
DATAFORMAT=${DATAFORMAT:-"NHWC"} # NCHW or NHWC
OUTPUT="/root/inference/vision/classification_and_detection/output"
DATE=$(date +"%s")

TAG="${MODEL}-${BACKEND}-${DEVICE}-${SCENARIO}"

PERF_OUTPUT_DIR=${OUTPUT_DIR}/${TAG}
mkdir -p ${PERF_OUTPUT_DIR}/results

if [[ ${BACKEND} == "pytorch" ]]; then
    DATAFORMAT="NCHW"
fi

MLPERF_FLAGS=(
    "${BACKEND}"
    "${MODEL}"
    "${DEVICE}"
    "--output ${OUTPUT}/${IMAGE##*:}-${DATE}"
    "--data-format ${DATAFORMAT}"
    "--scenario ${SCENARIO}"
    $([[ -z ${MAXTIME} ]] && echo "" || echo "--time ${MAXTIME}")
    $([[ -z ${THREADS} ]] && echo "" || echo "--threads ${THREADS}")
    $([[ -z ${COUNT} ]] && echo "" || echo "--count ${COUNT}")
    $([[ -z ${MAXBATCHSIZE} ]] && echo "" || echo "--max-batchsize ${MAXBATCHSIZE}")
)
COMMAND="./run_local.sh ${MLPERF_FLAGS[@]}"
if [[ -n ${PERF_FLAGS[@]} ]]; then
    COMMAND="perf record ${PERF_FLAGS[@]} -o ${OUTPUT}/${IMAGE##*:}-${DATE}/perf.data -- ${COMMAND}"
    PRIV="--privileged"
fi

WORKLOAD=(
    'docker run --rm -it'
    "-v $(pwd)/${PERF_OUTPUT_DIR}/results:${OUTPUT}"
    $([[ -z ${CPU} ]] && echo "" || echo "--cpuset-cpus ${CPU}")
    "-e DATA_DIR=${DATASET}"
    '-e MODEL_DIR=/root/models'
    "${PRIV}"
    "${IMAGE}"
    "bash -c 'mkdir -p ${OUTPUT}/${IMAGE##*:}-${DATE} && ${COMMAND}'"
)
echo ${WORKLOAD[@]}

