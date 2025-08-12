#!/bin/bash
# Script to pick an available i3 workspace, open terminal, VS Code, and Firefox

# Get list of used workspaces
USED_WS=$(i3-msg -t get_workspaces | jq '.[].num')
# Find the first unused workspace from 1 to 10
for i in {1..9}; do
	if ! echo "$USED_WS" | grep -q "^$i$"; then
		WS=$i
		break
	fi
done


# Abort if all workspaces are used
if [ -z "$WS" ]; then
	notify-send -u critical "All workspaces 1-9 are in use. Aborting script."
	echo "All workspaces 1-9 are in use. Aborting script."
	exit 1
fi


# Set workspace name dynamically based on the chosen workspace number
WS_NAME="$WS.siura"
i3-msg workspace "$WS_NAME"
i3-msg rename workspace to "$WS_NAME"

WORKING_DIRECTORY="$HOME/Projects/bitgroupasia/siura-web"

gnome-terminal --working-directory="$WORKING_DIRECTORY" &
code "$WORKING_DIRECTORY" &
firefox &

notify-send "Switched to workspace $WS"