#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

mkdir -p "$WALLPAPER_DIR"

notify() {
    if command -v notify-send >/dev/null; then
        notify-send "Wallpaper" "$1"
    fi
    echo "Wallpaper: $1"
}

set_wallpaper() {
    if [ ! -f "$1" ]; then
        notify "File not found: $1"
        exit 1
    fi

    if ! command -v swaybg >/dev/null; then
        notify "swaybg not installed"
        exit 1
    fi

    pkill -x swaybg 2>/dev/null
    sleep 0.1
    nohup swaybg -i "$1" -m fill >/tmp/swaybg.log 2>&1 &
    disown

    notify "Set: $(basename "$1")"
}

list_wallpapers() {
    find "$WALLPAPER_DIR" -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \
        -o -iname "*.gif"  -o -iname "*.bmp" \) 2>/dev/null
}

set_random_wallpaper() {
    local -a wallpapers
    mapfile -t wallpapers < <(list_wallpapers)

    if [ ${#wallpapers[@]} -eq 0 ]; then
        notify "No wallpapers in $WALLPAPER_DIR"
        exit 1
    fi

    set_wallpaper "${wallpapers[RANDOM % ${#wallpapers[@]}]}"
}

browse_wallpaper() {
    local -a wallpapers
    local selected

    if ! command -v wofi >/dev/null; then
        notify "wofi not installed (needed for browse)"
        exit 1
    fi

    mapfile -t wallpapers < <(list_wallpapers)

    if [ ${#wallpapers[@]} -eq 0 ]; then
        notify "No wallpapers in $WALLPAPER_DIR"
        exit 1
    fi

    selected=$(printf '%s\n' "${wallpapers[@]}" \
        | xargs -n1 basename \
        | wofi --dmenu --prompt "Select wallpaper")

    [ -n "$selected" ] && set_wallpaper "$WALLPAPER_DIR/$selected"
}

case "$1" in
    random|r)
        set_random_wallpaper
        ;;
    browse|b)
        browse_wallpaper
        ;;
    "")
        echo "Usage: $0 [random|browse|/path/to/wallpaper]"
        exit 1
        ;;
    *)
        set_wallpaper "$1"
        ;;
esac