#!/bin/bash

LOCK_FILE="/tmp/caffeine-lock"
SWAYIDLE_PID_FILE="/tmp/caffeine-swayidle.pid"

start_swayidle() {
    swayidle -w \
        timeout 300 'swaylock' \
        timeout 600 'swaymsg "output * dpms off"' \
            resume 'swaymsg "output * dpms on"' \
        before-sleep 'swaylock' &
    echo $! > "$SWAYIDLE_PID_FILE"
}

toggle() {
    if [ -f "$LOCK_FILE" ]; then
        disable
    else
        enable
    fi
}

enable() {
    touch "$LOCK_FILE"
    if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
        pkill swayidle 2>/dev/null
    else
        xset s off
        xset -dpms
        xdg-screensaver suspend 0xBEEF &
    fi
    notify-send -u normal "☕ Caffeine ON" "Sleep & screensaver disabled"
}

disable() {
    rm -f "$LOCK_FILE"
    if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
        start_swayidle
    else
        xset s on
        xset s 600 600
        xset +dpms
        xset dpms 600 600 600
    fi
    notify-send -u normal "💤 Caffeine OFF" "Sleep & screensaver enabled"
}

status() {
    if [ -f "$LOCK_FILE" ]; then
        echo "on"
    else
        echo "off"
    fi
}

case "$1" in
    toggle) toggle ;;
    on) enable ;;
    off) disable ;;
    status) status ;;
    *) echo "Usage: caffeine.sh [toggle|on|off|status]" ;;
esac
