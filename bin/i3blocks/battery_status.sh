#!/bin/bash
# Show current battery level and charging status
BATTERY=$(acpi -b 2>/dev/null)
if [ -z "$BATTERY" ]; then
  echo "No Battery"
  exit 0
fi
PERCENT=$(echo "$BATTERY" | grep -o '[0-9]\+%' | head -1)
STATUS=$(echo "$BATTERY" | grep -o 'Charging\|Discharging\|Full')
if [ "$STATUS" = "Charging" ]; then
  echo "$PERCENT ($STATUS)"
else
  echo "$PERCENT"
fi
echo "#800080"
