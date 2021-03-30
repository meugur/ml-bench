#!/bin/bash -e

PERF=/usr/bin/perf
RUNS=5

$PERF stat -o "${PERF_OUTPUT_DIR}/perf-cycles-instr.log" \
   -e cycles,cycles:k,instructions,instructions:k \
   -C ${CPU} \
   -r ${RUNS} \
   -- ${WORKLOAD[@]}

$PERF stat -o "${PERF_OUTPUT_DIR}/perf-icache-itlb.log" \
   -e L1-icache-load-misses,L1-icache-load-misses:k,iTLB-load-misses,iTLB-load-misses:k \
   -C ${CPU} \
   -r ${RUNS} \
   -- ${WORKLOAD[@]}
