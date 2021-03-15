#!/bin/bash -e

# Revert benchmarking environment
for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
do
    echo powersave | sudo tee $1
done
echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
echo 1 | sudo tee /proc/sys/kernel/nmi_watchdog
echo 4 | sudo tee /proc/sys/kernel/perf_event_paranoid
echo on | sudo tee /sys/devices/system/cpu/smt/control

