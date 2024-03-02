#!/bin/bash

#|---/ /+-----------------------------------+---/ /|#
#|--/ /-| Script to install aur helper, yay |--/ /-|#
#|-/ /--| Prasanth Rangan                   |-/ /--|#
#|/ /---+-----------------------------------+/ /---|#

banner_msg "Yay"

if pkg_installed yay; then
  echo "yay is already installed!"
else
  echo "Installing yay..."
  install_package_pacman "base-devel"
  SCRIPT=$(realpath "$0")
  temp_path=$(dirname "$SCRIPT")
  echo "$temp_path"
  git clone https://aur.archlinux.org/yay-bin.git ~/yay-bin
  cd ~/yay-bin || exit
  makepkg -si
  yay -Y --gendb
  yay -Y --devel --save
  cd "$temp_path" || exit
  success_msg "yay has been installed successfully."
fi
