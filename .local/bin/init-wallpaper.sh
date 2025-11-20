#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/wallpapers"
CACHE_DIR="$HOME/.cache"
CURRENT_WALLPAPER="$CACHE_DIR/current_wallpaper.jpg"
DEFAULT_WALLPAPER="$WALLPAPER_DIR/wallpaper.jpg"

mkdir -p "$CACHE_DIR"
mkdir -p "$WALLPAPER_DIR"

process_wallpaper() {
    local wallpaper_path="$1"
    
    if [ -f "$wallpaper_path" ]; then
        echo "Processing wallpaper: $wallpaper_path"
        
        # Copy wallpaper to cache
        cp "$wallpaper_path" "$CURRENT_WALLPAPER"
        
        # Generate colors with matugen
        if command -v matugen &> /dev/null; then
            matugen image "$wallpaper_path" 2>&1 | grep -v "Warning"
            echo "Colors generated successfully"
        else
            echo "Warning: matugen not found, skipping color generation"
        fi
    else
        echo "Error: Wallpaper not found at $wallpaper_path"
        return 1
    fi
}

if [ -f "$CURRENT_WALLPAPER" ]; then
    echo "Current wallpaper already exists at $CURRENT_WALLPAPER"
    exit 0
fi
if [ -f "$DEFAULT_WALLPAPER" ]; then
    process_wallpaper "$DEFAULT_WALLPAPER"
    exit 0
fi

FIRST_WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | head -n 1)

if [ -n "$FIRST_WALLPAPER" ]; then
    echo "No default wallpaper found, using: $FIRST_WALLPAPER"
    process_wallpaper "$FIRST_WALLPAPER"
    exit 0
fi

echo "No wallpapers found, creating fallback image"
if command -v convert &> /dev/null; then
    convert -size 1920x1080 xc:#1e1e2e "$CURRENT_WALLPAPER"
    echo "Created fallback wallpaper"
else
    echo "Error: No wallpaper available and ImageMagick not installed"
    exit 1
fi
