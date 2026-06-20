#!/bin/bash

WS=1
WS_NAME="$WS.comm"

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    swaymsg workspace "$WS_NAME"
    swaymsg rename workspace to "$WS_NAME"
else
    i3-msg workspace "$WS_NAME"
    i3-msg rename workspace to "$WS_NAME"
fi

firefox --new-window https://web.whatsapp.com/ &
