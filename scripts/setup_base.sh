#!/usr/bin/env bash

# ------------------------------------------------------
# * Import core functions and variables
# ------------------------------------------------------

source ./utils/color.sh
source ./utils/functions.sh

# ------------------------------------------------------
# * Pre install
# ------------------------------------------------------

# Preparation
source ./preparation.sh

# Pre setup
source ./pre_install.sh

# Install yay
source ./yay.sh

# ------------------------------------------------------
# * Install base
# ------------------------------------------------------

print_banner "Install"

# Load packages
source ./packages.sh

Install packages
install_packages_pacman "${base[@]}";
install_packages_yay "${cli_toos[@]}";
install_packages_yay "${assets[@]}";
install_packages_yay "${apps[@]}";

rm -rf $HOME/.config/fish
stow $HOME/dotfiles

source ./profile.sh

if [[ $profile == *"Hyprland"* ]]; then
    source ./setup-hyprland.sh
fi
if [[ $profile == *"Gnome"* ]]; then
    source ./setup-gnome.sh
fi

# ------------------------------------------------------
# * Post install
# ------------------------------------------------------

source ./sddm.sh
source ./cleanup.sh
source ./reboot.sh