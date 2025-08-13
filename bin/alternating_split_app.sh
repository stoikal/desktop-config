#!/bin/bash

# Script to open new windows with alternating split orientation
# Usage: alternating_split_app.sh [application_command] [arguments...]
# Example: alternating_split_app.sh firefox
# Example: alternating_split_app.sh code /path/to/project

STATE_FILE="$HOME/.config/i3/last_split_state"

# Ensure the config directory exists
mkdir -p "$(dirname "$STATE_FILE")"

# Get the number of windows in the current workspace
# Use i3-msg to get the current workspace and count windows
current_workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .name')
window_count=$(i3-msg -t get_tree | jq -r --arg workspace "$current_workspace" '
  recurse(.nodes[]?) | 
  select(.type == "workspace" and .name == $workspace) | 
  [recurse(.nodes[]?) | select(.window != null)] | 
  length
')

# Read the last split state, default to 'h' (horizontal) if file doesn't exist
if [ -f "$STATE_FILE" ]; then
    last_split=$(cat "$STATE_FILE")
else
    last_split="h"
fi

# Determine next split orientation
if [ "$window_count" -eq 1 ]; then
    # If there's only one window, always split horizontally
    next_split="h"
    echo "Only one window in workspace -> Splitting horizontally"
elif [ "$last_split" = "h" ]; then
    next_split="v"
    echo "Last split was horizontal -> Splitting vertically"
else
    next_split="h"
    echo "Last split was vertical -> Splitting horizontally"
fi

# Apply the split
i3-msg split "$next_split"

# Save the current split state for next time
echo "$next_split" > "$STATE_FILE"

# Open the new application with all arguments
if [ "$#" -gt 0 ]; then
    # Execute the command with all provided arguments
    exec "$@"
else
    # Default to opening a terminal if no arguments provided
    exec gnome-terminal
fi
