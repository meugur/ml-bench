#!/bin/bash -e

LEVEL=${1:-"l1"}

$(pwd)/pmu-tools/toplev.py \
    -${LEVEL} \
    --core ${CPU} \
    -v \
    --no-desc \
    --no-multiplex \
    -x, \
    -o "${PERF_OUTPUT_DIR}/toplev-cores-${LEVEL}.csv" \
    -- ${WORKLOAD[@]}

