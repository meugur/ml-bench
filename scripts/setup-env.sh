#!/bin/bash

source scripts/setup-perf-env.sh

# Setup benchmarking environment
for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo performance | sudo tee $i
done
echo 1 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
echo off | sudo tee /sys/devices/system/cpu/smt/control
echo 3 | sudo tee /proc/sys/vm/drop_caches && sync

