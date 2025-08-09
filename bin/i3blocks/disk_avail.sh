#!/bin/bash
# Show total available disk space (root filesystem)
df -h --output=avail / | tail -1 | xargs
