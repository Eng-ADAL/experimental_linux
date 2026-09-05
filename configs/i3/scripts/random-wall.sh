#!/usr/bin/env bash
WALLDIR="$HOME/Pictures/wallpapers"
FILE=$(find "$WALLDIR" -type f \( -iname '*.jpg' -o -iname '*.png' \) | shuf -n1)

if [ -n "$FILE" ]; then
    feh --bg-fill "$FILE"
fi

