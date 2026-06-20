#!/bin/bash

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    MSG="swaymsg"
else
    MSG="i3-msg"
fi

$MSG workspace "1.saktimart-be"
$MSG workspace "2.opencode"
$MSG workspace "3.saktimart-fe"
$MSG workspace "4.browser"

idea "$HOME/Projects/saktimart/saktimart-be" &
kitty --working-directory="$HOME/Projects/saktimart" -- opencode &
code "$HOME/Projects/saktimart/saktimart-fe" &
firefox http://localhost:8080/swagger-ui/index.html http://localhost:5173/ &

wait_for_window() {
    local target="$1"
    local timeout=30
    local elapsed=0
    while true; do
        if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
            if swaymsg -t get_tree | jq -e ".. | objects | select((.app_id // \"\") + (if .window_properties then .window_properties.class else \"\" end) | contains(\"$target\")) | select(.visible? == true)" 2>/dev/null | grep -q '"type"'; then
                return 0
            fi
        else
            if xdotool search --class "$target" &>/dev/null; then
                return 0
            fi
        fi
        sleep 0.5
        elapsed=$((elapsed + 1))
        if [ $elapsed -ge $((timeout * 2)) ]; then
            notify-send -u critical "Timeout waiting for $target"
            return 1
        fi
    done
}

wait_for_window "jetbrains-idea"
wait_for_window "kitty"
wait_for_window "code"
wait_for_window "Firefox"

$MSG '[class="jetbrains-idea"] move to workspace 1.saktimart-be'
$MSG '[class="kitty"] move to workspace 2.opencode'
$MSG '[class="code"] move to workspace 3.saktimart-fe'
$MSG '[class="Firefox"] move to workspace 4.browser'

$MSG workspace "1.saktimart-be"
