#!/usr/bin/env bash

# ------------------------------------------------------
# * Yay installation
# ------------------------------------------------------

if ! pacman -Qi "yay" &> /dev/null; then
    echo "Installing yay..."

    pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/yay-bin.git ~/yay-bin
    cd ~/yay-bin || exit
    makepkg -si
    yay -Y --gendb
    yay -Y --devel --save
    yay

    echo "yay has been installed successfully."
else
    echo -e "\033[0;33m[SKIP]\033[0m yay is already installed."
fi
