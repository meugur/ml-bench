#!/bin/bash -e

PERF=/usr/bin/perf
RUNS=5

sudo $PERF stat -o "${PERF_OUTPUT_DIR}/ports_util_0.log" \
    -e cycles,r1a6 \
    -C ${CPU} \
    -r ${RUNS} \
    -- ${WORKLOAD[@]}

sudo $PERF record -o "${PERF_OUTPUT_DIR}/perf.data.ports_util_0" \
    -a \
    -e r1a6 \
    -C ${CPU} \
    -r ${RUNS} \
    -- ${WORKLOAD[@]}

sudo $PERF stat -o "${PERF_OUTPUT_DIR}/ports_util_1.log" \
    -e cycles,r2a6 \
    -C ${CPU} \
    -r ${RUNS} \
    -- ${WORKLOAD[@]}

sudo $PERF record -o "${PERF_OUTPUT_DIR}/perf.data.ports_util_1" \
    -a \
    -e r2a6 \
    -C ${CPU} \
    -r ${RUNS} \
    -- ${WORKLOAD[@]}

sudo $PERF stat -o "${PERF_OUTPUT_DIR}/ports_util_2.log" \
    -e cycles,r4a6 \
    -C ${CPU} \
    -r ${RUNS} \
    -- ${WORKLOAD[@]}

sudo $PERF record -o "${PERF_OUTPUT_DIR}/perf.data.ports_util_2" \
    -a \
    -e r4a6 \
    -C ${CPU} \
    -r ${RUNS} \
    -- ${WORKLOAD[@]}

sudo $PERF stat -o "${PERF_OUTPUT_DIR}/ports_util_3.log" \
    -e cycles,r8a6 \
    -C ${CPU} \
    -r ${RUNS} \
    -- ${WORKLOAD[@]}

sudo $PERF record -o "${PERF_OUTPUT_DIR}/perf.data.ports_util_3" \
    -a \
    -e r8a6 \
    -C ${CPU} \
    -r ${RUNS} \
    -- ${WORKLOAD[@]}

sudo $PERF stat -o "${PERF_OUTPUT_DIR}/ports_util_4.log" \
    -e cycles,r10a6 \
    -C ${CPU} \
    -r ${RUNS} \
    -- ${WORKLOAD[@]}

sudo $PERF record -o "${PERF_OUTPUT_DIR}/perf.data.ports_util_4" \
    -a \
    -e r10a6 \
    -C ${CPU} \
    -r ${RUNS} \
    -- ${WORKLOAD[@]}

