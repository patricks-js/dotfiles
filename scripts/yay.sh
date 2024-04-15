#!/bin/bash

if pacman -Qi yay > /dev/null ; then
  echo "yay is already installed!"
else
  echo "Installing yay..."
  pacman -S --needed base-devel git
  git clone https://aur.archlinux.org/yay-bin.git ~/yay-bin
  cd ~/yay-bin || exit
  makepkg -si
  yay -Y --gendb
  yay -Y --devel --save
  echo "yay has been installed successfully."
fi
