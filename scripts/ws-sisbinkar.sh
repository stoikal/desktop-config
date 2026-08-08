#!/bin/bash

MSG="i3-msg"

USED_WS=$($MSG -t get_workspaces | jq '.[].num')
for i in {1..9}; do
    if ! echo "$USED_WS" | grep -q "^$i$"; then
        WS=$i
        break
    fi
done

if [ -z "$WS" ]; then
    notify-send -u critical "All workspaces 1-9 are in use. Aborting script."
    echo "All workspaces 1-9 are in use. Aborting script."
    exit 1
fi

WS_NAME="$WS.sisbinkar"
$MSG workspace "$WS_NAME"
$MSG rename workspace to "$WS_NAME"

kitty --working-directory="$HOME/Projects/bitgroupasia/sisbinkar-web" &
code "$HOME/Projects/bitgroupasia/sisbinkar-web" &
firefox --new-window http://localhost:3000 &

notify-send "Switched to workspace $WS"
