#!/bin/bash
# Launch pomo (top-right) and btm (bottom-right) in floating gnome-terminals on workspace 0

export PATH="$HOME/go/bin:$HOME/.cargo/bin:$PATH"

i3-msg workspace number 0
sleep 0.5

read -r SCREEN_W SCREEN_H < <(xdotool getdisplaygeometry)

WIN_W=$(( SCREEN_W * 44 / 100 ))
WIN_H=$(( SCREEN_H * 44 / 100 ))
MARGIN=32
MARGIN_X=120
POMO_Y=60
BTM_Y=$(( SCREEN_H - WIN_H - MARGIN ))
RIGHT_X=$(( SCREEN_W - WIN_W - MARGIN_X ))

gnome-terminal --role "pomo" --title "pomo" -- bash -c pomo &
gnome-terminal --role "btm" --title "btm" -- bash -c btm &

sleep 3

i3-msg "[window_role=\"^pomo$\"] floating enable, resize set ${WIN_W} px ${WIN_H} px, move position ${RIGHT_X} px ${POMO_Y} px"
i3-msg "[window_role=\"^btm$\"] floating enable, resize set ${WIN_W} px ${WIN_H} px, move position ${RIGHT_X} px ${BTM_Y} px"