#!/bin/bash
# Show currently connected Wi-Fi SSID
INFO=$(nmcli -t -f active,ssid,signal dev wifi | grep '^yes:')
SSID=$(echo "$INFO" | cut -d: -f2)
SIGNAL=$(echo "$INFO" | cut -d: -f3)
if [ -n "$SSID" ]; then
  echo "$SSID ($SIGNAL%)"
else
  echo "n/a"
fi
