#!/bin/bash
# Open Firefox in i3 workspace 1

i3-msg workspace number 1
firefox --new-window  https://web.whatsapp.com/ &
firefox --new-window https://gemini.google.com/ &
