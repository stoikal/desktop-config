#!/bin/bash

# Wallpaper management script for i3

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Create wallpaper directory if it doesn't exist
mkdir -p "$WALLPAPER_DIR"

# Function to set a specific wallpaper
set_wallpaper() {
    if [ -f "$1" ]; then
        feh --bg-fill "$1"
        echo "Wallpaper set to: $1"
    else
        echo "Error: Wallpaper file not found: $1"
        exit 1
    fi
}

# Function to set random wallpaper
set_random_wallpaper() {
    # Check if wallpaper directory has any images
    if [ -z "$(ls -A "$WALLPAPER_DIR"/*.{jpg,jpeg,png,gif,bmp} 2>/dev/null)" ]; then
        echo "No wallpapers found in $WALLPAPER_DIR"
        echo "Please add some image files to the wallpapers directory."
        exit 1
    fi
    
    # Set random wallpaper
    feh --bg-fill --randomize "$WALLPAPER_DIR"/*
    echo "Random wallpaper set from $WALLPAPER_DIR"
}

# Function to browse and select wallpaper using rofi
browse_wallpaper() {
    if ! command -v rofi &> /dev/null; then
        echo "rofi not found. Please install rofi or use other options."
        exit 1
    fi
    
    # Get list of wallpapers
    wallpapers=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) -printf "%f\n" 2>/dev/null)
    
    if [ -z "$wallpapers" ]; then
        echo "No wallpapers found in $WALLPAPER_DIR"
        exit 1
    fi
    
    # Use rofi to select wallpaper
    selected=$(echo "$wallpapers" | rofi -dmenu -p "Select wallpaper:")
    
    if [ -n "$selected" ]; then
        set_wallpaper "$WALLPAPER_DIR/$selected"
    fi
}

# Main script logic
case "$1" in
    "random"|"r")
        set_random_wallpaper
        ;;
    "browse"|"b")
        browse_wallpaper
        ;;
    "")
        echo "Usage: $0 [random|browse|/path/to/wallpaper]"
        echo "  random  - Set a random wallpaper from $WALLPAPER_DIR"
        echo "  browse  - Browse wallpapers using rofi"
        echo "  /path   - Set specific wallpaper file"
        ;;
    *)
        set_wallpaper "$1"
        ;;
esac
