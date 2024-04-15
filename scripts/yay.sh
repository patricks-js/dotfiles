#!/bin/bash

if ! pkg_installed yay; then
    echo -e "${BLUE}"
    echo "Installing yay..."
    echo -e "${NONE}"

    pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/yay-bin.git ~/yay-bin
    cd ~/yay-bin || exit
    makepkg -si
    yay -Y --gendb
    yay -Y --devel --save
    yay
    
    echo -e "${GREEN}"
    echo "yay has been installed successfully."
    echo -e "${NONE}"
fi
