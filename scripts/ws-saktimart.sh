#!/bin/bash

# Create workspaces
i3-msg workspace "1.saktimart-be"
i3-msg workspace "2.opencode"
i3-msg workspace "3.saktimart-fe"
i3-msg workspace "4.browser"

# Launch all apps
idea "$HOME/Projects/saktimart/saktimart-be" &
kitty --working-directory="$HOME/Projects/saktimart" -- opencode &
code "$HOME/Projects/saktimart/saktimart-fe" &
firefox http://localhost:8080/swagger-ui/index.html http://localhost:5173/ &

# Wait for windows to appear
wait_for_window() {
	local class="$1"
	local timeout=30
	local elapsed=0
	while ! xdotool search --class "$class" &>/dev/null; do
		sleep 0.5
		elapsed=$((elapsed + 1))
		if [ $elapsed -ge $((timeout * 2)) ]; then
			notify-send -u critical "Timeout waiting for $class"
			return 1
		fi
	done
}

wait_for_window "jetbrains-idea"
wait_for_window "kitty"
wait_for_window "code"
wait_for_window "Firefox"

# Move windows to correct workspaces
i3-msg '[class="jetbrains-idea"] move to workspace 1.saktimart-be'
i3-msg '[class="kitty"] move to workspace 2.opencode'
i3-msg '[class="code"] move to workspace 3.saktimart-fe'
i3-msg '[class="Firefox"] move to workspace 4.browser'

# Go to first workspace
i3-msg workspace "1.saktimart-be"
