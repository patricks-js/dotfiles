#!/bin/bash

# Cache file for holding the current wallpaper
cache_file="$HOME/.cache/current_wallpaper"
blurred="$HOME/.cache/blurred_wallpaper.png"
square="$HOME/.cache/square_wallpaper.png"
rasi_file="$HOME/.cache/current_wallpaper.rasi"

blur="50x30"

# Create cache file if not exists
if [ ! -f $cache_file ] ;then
    touch $cache_file
    echo "$HOME/wallpaper/default.png" > "$cache_file"
fi

# Create rasi file if not exists
if [ ! -f $rasi_file ] ;then
    touch $rasi_file
    echo "* { current-image: url(\"$HOME/wallpaper/default.png\", height); }" > "$rasi_file"
fi

current_wallpaper=$(cat "$cache_file")

# ----------------------------------------------------- 
# get wallpaper image name
# ----------------------------------------------------- 
wallpaper="$HOME/wallpaper/default.png"
newwall=$(echo $wallpaper | sed "s|$HOME/wallpaper/||g")

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
    
    # ----------------------------------------------------- 
    # Reload Hyprctl.sh
    # -----------------------------------------------------
    # $HOME/.config/ml4w-hyprland-settings/hyprctl.sh &
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
