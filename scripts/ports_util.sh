#!/bin/bash -e

PERF=/usr/bin/perf
RUNS=5

sudo $PERF record -o "${PERF_OUTPUT_DIR}/perf.data.cycles.r1a6" \
    -a \
    -e cycles,r1a6 \
    -C ${CPU} \
    -r ${RUNS} \
    -- ${WORKLOAD[@]}

sudo $PERF record -o "${PERF_OUTPUT_DIR}/perf.data.r2a6.r4a6.r8a6.r10a6" \
    -a \
    -e r2a6,r4a6,r8a6,r10a6 \
    -C ${CPU} \
    -r ${RUNS} \
    -- ${WORKLOAD[@]}
