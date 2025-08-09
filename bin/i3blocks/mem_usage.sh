#!/bin/bash
# Get memory in MB, convert to GB with 1 decimal
read total used <<< $(free -m | awk '/^Mem:/ {print $2, $3}')
used_gb=$(awk "BEGIN {printf \"%.1f\", $used/1024}")
total_gb=$(awk "BEGIN {printf \"%.1f\", $total/1024}")
echo "$used_gb/$total_gb GB"
