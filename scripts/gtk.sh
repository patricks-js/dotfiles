#!/usr/bin/env bash

# ------------------------------------------------------
# * GTK theme config
# ------------------------------------------------------

if ! yay -Qi "catppuccin-gtk-theme-mocha" &> /dev/null; then
    yay -S catppuccin-gtk-theme-mocha
fi

accent="Standard-Blue-Dark"
theme_dir=/usr/share/themes/Catppuccin-Mocha-$accent
gtk_dir=$HOME/.config/gtk-4.0

rm -rf "$gtk_dir/*"

ln -sf "$theme_dir/gtk-4.0/assets" "$gtk_dir/assets"
ln -sf "$theme_dir/gtk-4.0/gtk.css" "$gtk_dir/gtk.css"
ln -sf "$theme_dir/gtk-4.0/gtk-dark.css" "$gtk_dir/gtk-dark.css"
