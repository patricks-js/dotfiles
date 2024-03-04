#!/bin/bash
#|---/ /+--------------------------+---/ /|#
#|--/ /-| General packages         |--/ /-|#
#|-/ /--| @_patrick.js             |-/ /--|#
#|/ /---+--------------------------+/ /---|#

# ------------------------------------------------------
# ? Core packages with pacman
# ------------------------------------------------------

pacman_packages_lst=(
  "gum"
  "zip"
  "gvfs"
  "gtk3"
  "gtk4"
  "pipewire"
  "pipewire-alsa"
  "pipewire-audio"
  "pipewire-jack"
  "pipewire-pulse"
  "gst-plugin-pipewire"
  "wireplumber"
  "bluez"
  "bluez-utils"
  "blueman"
  "networkmanager"
  "network-manager-applet"
  "ufw"
  "ufw-extras"
  "fish"
  "pacman-contrib"
  "wget"
  "openssh"
  "unzip"
  "freerdp"
  "mousepad"
  "tumbler"
  "polkit-git"
  "brightnessctl"
  "pavucontrol"
  "man-pages"
  "ark"
  "xdg-user-dirs"
  "xdg-desktop-portal"
  "xdg-utils"
)

install_package_pacman "${pacman_packages_lst[@]}"

# ------------------------------------------------------
# ? Hyprland packages with yay
# ------------------------------------------------------

hyprland_packages_lst=(
  "jq"
  "rustup"
  "sddm"
  "swww"
  "slurp"
  "kitty"
  "qt5ct"
  "qt6ct"
  "dunst"
  "swappy"
  "waybar"
  "dolphin"
  "kvantum"
  "wlogout"
  "eww-git"
  "hyprland"
  "swayidle"
  "cliphist"
  "parallel"
  "imagemagick"
  "qt5-wayland"
  "qt6-wayland"
  "nwg-look-bin"
  "kde-cli-tools"
  "grimblast-git"
  "polkit-kde-agent"
  "qt5-imageformats"
  "qt5-quickcontrols"
  "qt5-quickcontrols2"
  "rofi-lbonn-wayland"
  "qt5-graphicaleffects"
  "swaylock-effects-git"
  "xdg-desktop-portal-hyprland"
)

install_package_yay "${hyprland_packages_lst[@]}"

# ------------------------------------------------------
# ? Assets (fonts, etc...) with yay
# ------------------------------------------------------

yay_assets_lst=(
  "emote"
  "noto-fonts"
  "papirus-icon-theme"
  "ttf-jetbrains-mono-nerd"
  "bibata-cursor-theme-bin"
  "ttf-material-design-icons-extended"
)

install_package_yay "${yay_assets_lst[@]}"

chsh -s /usr/bin/fish
