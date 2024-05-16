#!/usr/bin/env bash

source fn.sh

if pkg_installed yay; then
    echo -e "\033[0;33m[SKIP]\033[0m yay is already installed."
    exit 0
fi

if [ -d ~/aur_temp ]; then
    echo "~/aur_temp directory exists..."
    rm -rf ~/aur_temp/yay
fi

echo "Installing yay..."

pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay-bin.git ~/aur_temp/yay
cd ~/yay-bin || exit
makepkg ${use_default} -si
yay -Y --gendb
yay -Y --devel --save
yay

echo "yay has been installed successfully."
rm -rf ~/aur_temp
