#!/bin/bash

# Enhanced i3lock wrapper script
# Usage: i3lock-enhanced.sh [style]
# Styles: image, fancy, fancy-grey, fancy-pixel, colored

LOCKSCREEN_DIR="/home/xlwp/Pictures/Lockscreen"

# Function to use standard i3lock with image
lock_with_image() {
    local image=$(find "$LOCKSCREEN_DIR" -type f -name "*.png" | shuf -n 1)
    if [ -f "$image" ] && [ -r "$image" ]; then
        i3lock -i "$image"
    else
        i3lock -c 000000
    fi
}

# Function to use i3lock-fancy (blur effect)
lock_with_fancy() {
    local style="$1"
    case "$style" in
        "fancy-grey")
            i3lock-fancy --greyscale
            ;;
        "fancy-pixel")
            i3lock-fancy --pixelate
            ;;
        *)
            i3lock-fancy
            ;;
    esac
}

# Function to use colored background
lock_with_color() {
    # Use a dark color background
    i3lock -c 1a1a1a
}

# Function to create custom colored overlay on image
lock_with_colored_overlay() {
    local image=$(find "$LOCKSCREEN_DIR" -type f -name "*.png" | shuf -n 1)
    local temp_image="/tmp/lockscreen_overlay.png"
    
    if [ -f "$image" ] && [ -r "$image" ]; then
        # Create image with colored overlay
        convert "$image" \
            -fill "rgba(26,26,26,0.3)" \
            -draw "rectangle 0,0 1920,1080" \
            "$temp_image"
        i3lock -i "$temp_image"
        rm -f "$temp_image"
    else
        lock_with_color
    fi
}

# Main logic based on style parameter
case "${1:-image}" in
    "fancy")
        lock_with_fancy
        ;;
    "fancy-grey")
        lock_with_fancy "fancy-grey"
        ;;
    "fancy-pixel")
        lock_with_fancy "fancy-pixel"
        ;;
    "colored")
        lock_with_color
        ;;
    "overlay")
        lock_with_colored_overlay
        ;;
    "custom-colors"|"image"|*)
        lock_with_image
        ;;
esac
