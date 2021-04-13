#!/bin/bash

source scripts/revert-perf-env.sh

# Revert benchmarking environment
echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
echo on | sudo tee /sys/devices/system/cpu/smt/control
for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo powersave | sudo tee $i
done

