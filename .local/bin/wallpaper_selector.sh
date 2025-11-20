#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_FILE="$HOME/.cache/current_wallpaper.jpg"

# Check if directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    mkdir -p "$WALLPAPER_DIR"
    echo "Please put some wallpapers in $WALLPAPER_DIR"
    exit 1
fi

# Select wallpaper
SELECTED=$(ls "$WALLPAPER_DIR" | rofi -dmenu -p "Wallpaper")

if [ -n "$SELECTED" ]; then
    FULL_PATH="$WALLPAPER_DIR/$SELECTED"
    
    # Copy to cache
    cp "$FULL_PATH" "$CACHE_FILE"
    
    # Set wallpaper with hyprpaper
    # We need to unload all first to avoid cache issues or just reload
    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload "$CACHE_FILE"
    hyprctl hyprpaper wallpaper ",$CACHE_FILE"
    
    # Generate colors with Matugen
    matugen image "$FULL_PATH"
    
    # Reload Waybar to apply new colors
    pkill waybar && waybar &
    
    # Notify
    notify-send "Wallpaper changed" "Colors regenerated from $SELECTED"
fi
