#!/bin/bash -e

echo 0 | sudo tee /proc/sys/kernel/nmi_watchdog
echo -1 | sudo tee /proc/sys/kernel/perf_event_paranoid

