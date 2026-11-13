#!/bin/bash
# Watches for HDMI-A-0 hotplug and re-applies the screenlayout when it connects.

OUTPUT="HDMI-A-0"
LAYOUT="$HOME/.screenlayout/top-btm.sh"
LOCKFILE="${XDG_RUNTIME_DIR:-/tmp}/monitor-hotplug.lock"

# Single-instance guard (i3 uses exec_always)
exec 9>"$LOCKFILE"
flock -n 9 || exit 0

is_connected() {
    local out
    out=$(xrandr --query 2>/dev/null) || return 2
    grep -q "^$OUTPUT connected" <<<"$out"
}

apply_layout() {
    "$LAYOUT"
}

prev=0
is_connected
rc=$?
if [ "$rc" -eq 0 ]; then
    apply_layout
    prev=1
fi

while true; do
    sleep 2
    is_connected
    rc=$?
    case $rc in
        0)
            [ "$prev" -eq 0 ] && apply_layout
            prev=1
            ;;
        1)
            prev=0
            ;;
        *) ;; # xrandr/X unavailable: keep previous state, retry
    esac
done
