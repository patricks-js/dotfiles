#!/usr/bin/env bash

source fn.sh

if [ ! -f ~/.cache/wal/colors-hyprland.conf ]; then
    wal -i ~/wallpaper/default.jpg
    echo "Pywal and templates activated."
    echo ""
else
    echo "Pywal already activated."
    echo ""
fi

if pkg_installed nemo; then
    gsettings set org.cinnamon.desktop.default-applications.terminal exec kitty && \
    gsettings set org.nemo.preferences.menu-config background-menu-open-as-root false && \
    gsettings set org.nemo.preferences.menu-config selection-menu-open-as-root false && \
    gsettings set org.nemo.preferences thumbnail-limit 10485760

    xdg-mime default nemo.desktop inode/directory
    echo "setting" $(xdg-mime query default "inode/directory") "as default file explorer..."
fi
