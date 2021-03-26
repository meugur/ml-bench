#!/bin/bash -e

LEVEL=${1:-"l1"}

$(pwd)/pmu-tools/toplev.py \
    -${LEVEL} \
    --core C${CPU}-T0,C${CPU}-T1 \
    -v \
    --no-desc \
    --no-multiplex \
    -x, \
    -o "${PERF_OUTPUT_DIR}/toplev-smt-${LEVEL}.csv" \
    -- ${WORKLOAD[@]}

