#!/bin/bash -e

LEVEL=${1:-"l1"}

$(pwd)/pmu-tools/toplev.py \
    -${LEVEL} \
    -C${CPU} \
    -v \
    --no-desc \
    --single-thread \
    --no-multiplex \
    -I ${INTERVAL} \
    --graph \
    --graph-cpu C${CPU}-T${CPU} \
    --title ${TAG} \
    -o "${PERF_OUTPUT_DIR}/${TAG}/${LEVEL}-plot.png" \
    -- ${WORKLOAD[@]}

