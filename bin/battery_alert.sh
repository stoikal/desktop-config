#!/bin/bash
# battery_alert.sh: Show alert if battery falls below 20% and is discharging

BATTERY=$(acpi -b 2>/dev/null)
if [ -z "$BATTERY" ]; then
  exit 0
fi
PERCENT=$(echo "$BATTERY" | grep -o '[0-9]\+%' | head -1)
PERCENT_NUM=$(echo "$PERCENT" | tr -d '%')
STATUS=$(echo "$BATTERY" | grep -o 'Charging\|Discharging\|Full')

if [ "$PERCENT_NUM" -lt 20 ] && [ "$STATUS" = "Discharging" ]; then
  notify-send -u critical "Battery low" "Battery is at $PERCENT. Plug in your charger!"
fi
