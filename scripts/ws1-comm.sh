#!/bin/bash
# Open Firefox in i3 workspace 1


# Set workspace name
WS=1
WS_NAME="$WS.comm"
i3-msg workspace "$WS_NAME"
i3-msg rename workspace to "$WS_NAME"

firefox --new-window https://web.whatsapp.com/ &
firefox --new-window https://gemini.google.com/ &
