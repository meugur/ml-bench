#!/bin/bash -e

# Setup benchmarking environment
echo 1 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
do
    echo performance | sudo tee $1
done
echo 0 | sudo tee /proc/sys/kernel/nmi_watchdog
echo -1 | sudo tee /proc/sys/kernel/perf_event_paranoid
echo off | sudo tee /sys/devices/system/cpu/smt/control
echo 3 | sudo tee /proc/sys/vm/drop_caches && sync

