#!/bin/bash

# i3lock wrapper script for xss-lock
# This script handles automatic lockscreen for system suspend/hibernate

LOCKSCREEN_DIR="/home/xlwp/Pictures/Lockscreen"

# Find a random PNG image from the lockscreen directory
LOCKSCREEN_IMAGE=$(find "$LOCKSCREEN_DIR" -type f -name "*.png" | shuf -n 1)

# Check if we found a PNG image
if [ -f "$LOCKSCREEN_IMAGE" ] && [ -r "$LOCKSCREEN_IMAGE" ]; then
    # Use random image background with --nofork for xss-lock
    i3lock -i "$LOCKSCREEN_IMAGE" --nofork
else
    # Fallback to dark background with --nofork for xss-lock
    i3lock -c 1a1a1a --nofork
fi
