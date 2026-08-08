#!/bin/bash

WS=1
WS_NAME="$WS.comm"

i3-msg workspace "$WS_NAME"
i3-msg rename workspace to "$WS_NAME"

firefox --new-window https://web.whatsapp.com/ &
