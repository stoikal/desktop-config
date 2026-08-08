#!/bin/bash

LOCK_FILE="/tmp/caffeine-lock"

toggle() {
    if [ -f "$LOCK_FILE" ]; then
        disable
    else
        enable
    fi
}

enable() {
    touch "$LOCK_FILE"
    xset s off
    xset -dpms
    xdg-screensaver suspend 0xBEEF &
    notify-send -u normal "☕ Caffeine ON" "Sleep & screensaver disabled"
}

disable() {
    rm -f "$LOCK_FILE"
    xset s on
    xset s 600 600
    xset +dpms
    xset dpms 600 600 600
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
