#!/usr/bin/env bash

if sudo pacman -Qs yay > /dev/null ; then
    echo ":: yay is already installed!"
else
    echo "Installing yay..."

    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/yay-bin.git ~/yay
    cd ~/yay || exit
    makepkg -si
    yay -Y --gendb
    yay -Y --devel --save
    yay

    echo "yay has been installed successfully."
    rm -rf ~/yay
fi
echo
