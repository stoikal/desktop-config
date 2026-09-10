#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
STATE_FILE="$HOME/.cache/desktop-config/wallpaper-last"

mkdir -p "$WALLPAPER_DIR"

kill_bg() {
    pkill feh 2>/dev/null
}

save_wallpaper() {
    mkdir -p "$(dirname "$STATE_FILE")"
    echo "$1" > "$STATE_FILE"
}

set_wallpaper() {
    if [ -f "$1" ]; then
        kill_bg
        feh --bg-fill "$1"
        save_wallpaper "$1"
        echo "Wallpaper set to: $1"
    else
        echo "Error: Wallpaper file not found: $1"
        exit 1
    fi
}

set_random_wallpaper() {
    wallpapers=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) 2>/dev/null)

    if [ -z "$wallpapers" ]; then
        echo "No wallpapers found in $WALLPAPER_DIR"
        exit 1
    fi

    selected=$(echo "$wallpapers" | shuf -n 1)
    set_wallpaper "$selected"
    echo "Random wallpaper set from $WALLPAPER_DIR"
}

set_cycle_wallpaper() {
    wallpapers=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) 2>/dev/null | sort)

    if [ -z "$wallpapers" ]; then
        echo "No wallpapers found in $WALLPAPER_DIR"
        exit 1
    fi

    readarray -t list <<< "$wallpapers"
    count=${#list[@]}

    next=0
    if [ -f "$STATE_FILE" ]; then
        last=$(cat "$STATE_FILE")
        for (( i=0; i<count; i++ )); do
            if [ "$last" == "${list[$i]}" ]; then
                next=$(( (i + 1) % count ))
                break
            fi
        done
    fi

    set_wallpaper "${list[$next]}"
    echo "Cycled wallpaper to: ${list[$next]}"
}

set_persistent_wallpaper() {
    if [ -f "$STATE_FILE" ]; then
        set_wallpaper "$(cat "$STATE_FILE")"
    else
        echo "No saved wallpaper found; use random or browse first"
    fi
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
    "cycle"|"c")
        set_cycle_wallpaper
        ;;
    "browse"|"b")
        browse_wallpaper
        ;;
    "persist"|"last")
        set_persistent_wallpaper
        ;;
    "")
        echo "Usage: $0 [random|cycle|browse|persist|/path/to/wallpaper]"
        echo "  random  - Set a random wallpaper from $WALLPAPER_DIR"
        echo "  cycle   - Set the next wallpaper (cyclic)"
        echo "  browse  - Browse wallpapers using rofi"
        echo "  persist - Set the last saved wallpaper"
        echo "  /path   - Set specific wallpaper file"
        ;;
    *)
        set_wallpaper "$1"
        ;;
esac
