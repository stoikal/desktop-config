#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

mkdir -p "$WALLPAPER_DIR"

kill_bg() {
    pkill feh 2>/dev/null
}

set_wallpaper() {
    if [ -f "$1" ]; then
        kill_bg
        feh --bg-fill "$1"
        echo "Wallpaper set to: $1"
    else
        echo "Error: Wallpaper file not found: $1"
        exit 1
    fi
}

set_random_wallpaper() {
    if [ -z "$(ls -A "$WALLPAPER_DIR"/*.{jpg,jpeg,png,gif,bmp} 2>/dev/null)" ]; then
        echo "No wallpapers found in $WALLPAPER_DIR"
        exit 1
    fi

    kill_bg
    feh --bg-fill --randomize "$WALLPAPER_DIR"/*
    echo "Random wallpaper set from $WALLPAPER_DIR"
}

browse_wallpaper() {
    if ! command -v rofi &> /dev/null; then
        echo "rofi not found"
        exit 1
    fi

    wallpapers=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) -printf "%f\n" 2>/dev/null)

    if [ -z "$wallpapers" ]; then
        echo "No wallpapers found in $WALLPAPER_DIR"
        exit 1
    fi

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
