#!/bin/bash
# cpu_usage.sh: Print CPU usage as a percentage

# Get the CPU usage using top, awk, and grep
CPU_IDLE=$(top -bn1 | grep '%Cpu' | awk '{print $8}')
CPU_USAGE=$(echo "100 - $CPU_IDLE" | bc)
echo "$CPU_USAGE%"
