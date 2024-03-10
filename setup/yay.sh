#!/bin/bash

if pacman -Qi yay; then
  echo "yay is already installed!"
else
  echo "Installing yay..."
  git clone https://aur.archlinux.org/yay-bin.git ~/yay-bin
  cd ~/yay-bin || exit
  makepkg -si
  yay -Y --gendb
  yay -Y --devel --save
  echo "yay has been installed successfully."
fi
