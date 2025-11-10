#!/usr/bin/env bash

WALL_DIR="$HOME/Wallpapers"
INTERVAL=600  # tempo em segundos (10 min)

[[ -d "$WALL_DIR" ]] || exit 1

while true; do
    MONITORS=$(hyprctl monitors -j | jq -r '.[].name')
    for MON in $MONITORS; do
        PREV_FILE="$HOME/.cache/hyprpaper-last-$MON"
        CURRENT=$(cat "$PREV_FILE" 2>/dev/null)
        NEW=$(find "$WALL_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' \) ! -name "$(basename "$CURRENT")" | shuf -n 1)

        [[ -n "$NEW" ]] || continue
        echo "$NEW" > "$PREV_FILE"
        hyprctl hyprpaper reload "$MON,$NEW" >/dev/null 2>&1
    done
    sleep "$INTERVAL"
done
