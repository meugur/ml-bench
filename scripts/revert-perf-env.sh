#!/bin/bash -e

echo 1 | sudo tee /proc/sys/kernel/nmi_watchdog
echo 4 | sudo tee /proc/sys/kernel/perf_event_paranoid

