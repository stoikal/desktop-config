#!/bin/bash
# Rename the active workspace (i3-style: MOD+N)
# Empty input clears the custom name back to the numeric id.

ID=$(hyprctl activeworkspace -j | jq -r '.id')

NAME=$(wofi --dmenu --insensitive --prompt "New name for this workspace: ") || exit 0

# Escape for embedding in a Lua string (hyprctl dispatch parses args as Lua since 0.55)
NAME=$(printf '%s' "$NAME" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g')

hyprctl dispatch "hl.dsp.workspace.rename({ workspace = $ID, name = \"$NAME\" })"