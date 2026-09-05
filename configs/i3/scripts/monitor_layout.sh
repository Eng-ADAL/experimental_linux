#!/bin/sh

# Simple monitor layout switcher
# Usage: monitor_layout.sh <layout>

INTERNAL="eDP-1"
EXTERNAL="HDMI-1"
STATE_FILE="$HOME/.cache/monitor_layout.state"



case "$1" in
    external)
        xrandr --output "$INTERNAL" --off --output "$EXTERNAL" --primary --auto
        ;;
    dual-left)
        xrandr --output "$EXTERNAL" --auto --left-of "$INTERNAL" \
               --output "$INTERNAL" --primary --auto
        ;;
    dual-right)
        xrandr --output "$EXTERNAL" --auto --right-of "$INTERNAL" \
               --output "$INTERNAL" --primary --auto
        ;;
    dual-up)
        xrandr --output "$EXTERNAL" --auto --above "$INTERNAL" \
               --output "$INTERNAL" --primary --auto
        ;;
    internal)
        xrandr --output "$EXTERNAL" --off --output "$INTERNAL" --primary --auto
        ;;
    *)
        echo "Usage: $0 {external|dual-left|dual-right|dual-up|internal}"
        exit 1
        ;;
esac

echo "LAYOUT=$1" > "$STATE_FILE"


