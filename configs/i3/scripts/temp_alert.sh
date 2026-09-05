#!/bin/bash

# Get max CPU temp
MAX_TEMP=$(sensors | awk '/Core/ {gsub(/\+/,"",$2); gsub(/°C/,"",$3); if($3>t){t=$3}} END{print t}')

# Alert if over 80°C
if [ "$MAX_TEMP" -ge 80 ]; then
    rofi -e "🔥 CPU overheating! $MAX_TEMP°C"
fi

