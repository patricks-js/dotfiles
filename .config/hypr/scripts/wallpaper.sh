#!/bin/bash

# Cache file for holding the current wallpaper
path_dir="$HOME/wallpaper"
cache_file="$HOME/.cache/current_wallpaper"
blurred="$HOME/.cache/blurred_wallpaper.png"
square="$HOME/.cache/square_wallpaper.png"
rasi_file="$HOME/.cache/current_wallpaper.rasi"

blur="50x30"

# Create cache file if not exists
if [ ! -f $cache_file ] ;then
    touch $cache_file
    echo "$path_dir/default.png" > "$cache_file"
fi

# Create rasi file if not exists
if [ ! -f $rasi_file ] ;then
    touch $rasi_file
    echo "* { current-image: url(\"$path_dir/default.png\", height); }" > "$rasi_file"
fi

current_wallpaper=$(cat "$cache_file")
# ----------------------------------------------------- 
# Get random wallpaper image
# ----------------------------------------------------- 
walls=$(find "$path_dir/" -type f \( -name "*.png" -o -name "*.jpg" \))

if [ -z "$walls" ]; then
    echo "No one wallpaper found in '$path_dir'."
    exit 1
fi

wallpaper=$(find "$HOME/wallpaper/" -type f \( -name "*.png" -o -name "*.jpg" \) | shuf -n 1)
newwall=$(echo $wallpaper | sed "s|$path_dir/||g")

# ----------------------------------------------------- 
# Set the new wallpaper
# -----------------------------------------------------
transition_type="wipe"
# transition_type="outer"
# transition_type="random"

wal_tpl="""
# Preload Wallpapers
preload = $wallpaper
# Set Wallpapers
wallpaper = ,$wallpaper

#enable splash text rendering over the wallpaper
splash = false
"""

killall hyprpaper
echo "$wal_tpl" > $HOME/dotfiles/.config/hypr/hyprpaper.conf
hyprpaper &

if [ "$1" == "init" ] ;then
    echo ":: Init"
else
    sleep 1
    notify-send "Changing wallpaper ..." "with image $newwall"
fi

# ----------------------------------------------------- 
# Created blurred wallpaper
# -----------------------------------------------------
if [ "$1" == "init" ] ;then
    echo ":: Init"
else
    notify-send "Creating blurred version ..." "with image $newwall"
fi

magick $wallpaper -resize 75% $blurred
echo ":: Resized to 75%"
if [ ! "$blur" == "0x0" ] ;then
    magick $blurred -blur $blur $blurred
    echo ":: Blurred"
fi

# ----------------------------------------------------- 
# Write selected wallpaper into .cache files
# ----------------------------------------------------- 
echo "$wallpaper" > "$cache_file"
echo "* { current-image: url(\"$blurred\", height); }" > "$rasi_file"

# ----------------------------------------------------- 
# Send notification
# ----------------------------------------------------- 

if [ "$1" == "init" ] ;then
    echo ":: Init"
else
    notify-send "Wallpaper procedure complete!" "with image $newwall"
fi

echo "DONE!"
