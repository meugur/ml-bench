#!/bin/bash -e

LEVEL=${1:-"l1"}

$(pwd)/pmu-tools/toplev.py \
    -${LEVEL} \
    -C${CPU} \
    -v \
    --no-desc \
    --single-thread \
    --no-multiplex \
    -x, \
    -o "${PERF_OUTPUT_DIR}/toplev-${LEVEL}.csv" \
    -- ${WORKLOAD[@]}

