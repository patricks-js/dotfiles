#!/usr/bin/env bash

CACHE_DIR="$HOME/.cache"
CURRENT_WALLPAPER="$CACHE_DIR/current_wallpaper.jpg"

if [ -z "$1" ]; then
    echo "Usage: $0 <path-to-wallpaper>"
    echo "Example: $0 ~/wallpapers/wallpaper.jpg"
    exit 1
fi

WALLPAPER_PATH="$1"

if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Error: Wallpaper file not found: $WALLPAPER_PATH"
    exit 1
fi

echo "Changing wallpaper to: $WALLPAPER_PATH"

cp "$WALLPAPER_PATH" "$CURRENT_WALLPAPER"
echo "Wallpaper copied to cache"

if command -v matugen &> /dev/null; then
    echo "Generating color scheme with matugen..."
    matugen image "$WALLPAPER_PATH"
    echo "Colors generated successfully"
else
    echo "Warning: matugen not found, skipping color generation"
fi

if pgrep -x "hyprpaper" > /dev/null; then
    echo "Reloading hyprpaper..."
    killall hyprpaper
    hyprpaper &
    echo "Hyprpaper reloaded"
fi

if pgrep -x "waybar" > /dev/null; then
    echo "Reloading waybar..."
    killall waybar
    waybar &
    echo "Waybar reloaded"
fi

echo "Wallpaper changed successfully!"
