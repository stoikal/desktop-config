#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
STATE_FILE="$HOME/.cache/desktop-config/wallpaper-last"

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

    mkdir -p "$(dirname "$STATE_FILE")"
    echo "$1" > "$STATE_FILE"

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

set_cycle_wallpaper() {
    local -a wallpapers
    mapfile -t wallpapers < <(list_wallpapers | sort)

    if [ ${#wallpapers[@]} -eq 0 ]; then
        notify "No wallpapers in $WALLPAPER_DIR"
        exit 1
    fi

    local next=0 last i
    if [ -f "$STATE_FILE" ]; then
        last=$(cat "$STATE_FILE")
        for i in "${!wallpapers[@]}"; do
            if [ "$last" == "${wallpapers[$i]}" ]; then
                next=$(( (i + 1) % ${#wallpapers[@]} ))
                break
            fi
        done
    fi

    set_wallpaper "${wallpapers[$next]}"
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
    cycle|c)
        set_cycle_wallpaper
        ;;
    browse|b)
        browse_wallpaper
        ;;
    "")
        echo "Usage: $0 [random|cycle|browse|/path/to/wallpaper]"
        exit 1
        ;;
    *)
        set_wallpaper "$1"
        ;;
esac