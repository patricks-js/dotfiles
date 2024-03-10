#!/bin/bash

# ------------------------------------------------------
# ? Functions
# ------------------------------------------------------

pkg_installed() {
  local package=$1
  
  if yay -Qi "$package" &>/dev/null; then
    echo "$package is already installed."
    return 0
  else
    echo "$package is not installed."
    return 1
  fi
}

install_pacman() {
  local packages=("$@")

  for package in "${packages[@]}"; do
    if ! pkg_installed "$package"; then
      echo "Installing $package..."
      sudo pacman --noconfirm -S "$package"
      echo "Success"
    fi
  done
}

install_yay() {
  local packages=("$@")

  for package in "${packages[@]}"; do
    if ! pkg_installed "$package"; then
      echo "Installing $package..."
      yay --noconfirm -S "$package"
      echo "Success"
    fi
  done
}

# ------------------------------------------------------
# ? Essential packages
# ------------------------------------------------------

audio_server_list=(
  "pipewire"
  "pipewire-jack"
  "pipewire-alsa"
  "pipewire-audio"
  "pipewire-pulse"
  "gst-plugin-pipewire"
  "wireplumber"
  "libpulse"
)

install_pacman ${audio_server_list[@]}

desktop_env_list=(
  "sddm"
  "gnome-tweaks"
  "xdg-utils"
  "xdg-desktop-portal"
)

install_pacman ${desktop_env_list[@]}

bluetooth_list=(
  "bluez"
  "bluez-utils"
)

firewall_list=(
  "ufw"
  "ufw-extras"
)

network_list=(
  "openssh"
  "networkmanager"
  "network-manager-applet"
  "wireless_tools"
  "wpa_supplicant"
)

extra_packages=(
  "smartmontools"
  "wget"
  "neovim"
  "zoxide"
  "tokei"
  "cava"
  "neofetch"
  "tmux"
  "stow"
  "bat"
  "fzf"
  "starship"
  "lsd"
  "flatpak"
  "libvirtd"
)

assets_list=(
  "emote"
  "noto-fonts"
  "noto-fonts-cjk"
  "noto-fonts-emoji"
  "papirus-icon-theme"
  "ttf-jetbrains-mono-nerd"
  "bibata-cursor-theme-bin"
  "pop-fonts"
  "ttf-material-design-icons-extended"
)

drivers_list=(
  "mesa"
  "libva-intel-driver"
  "intel-media-driver"
  "xorg-xwayland"
  "vulkan-intel"
  "xorg-server"
  "xorg-xinit"
)

codecs_list=(
  "ffmpeg"
  "gst-plugins-base"
  "gst-plugins-good"
  "gstreamer"
  "gst-plugins-ugly"
  "gst-libav"
  "libvorbis"
  "libdv"
  "libjpeg-turbo"
  "libpng"
  "giflib"
  "libwebp"
)

# ------------------------------------------------------
# ? Extra packages
# ------------------------------------------------------

packages_list=(
  "qt5-svg"
  "imagemagick"
  "qt5-quickcontrols2"
  "qt5-graphicaleffects"
  "gtk3"
  "gtk4"
  "fish"
  "pacman-contrib"
  "zip"
  "unzip"
  "polkit-git"
  "man-pages"
  "xdg-user-dirs"
)

programs_list=(
  "obsidian"
  "discord"
  "brave-bin"
  "visual-studio-code-bin"
  "mpv"
  "ulauncher"
  "obs-studio"
  "firefox"
)

list=(
  "${bluetooth_list[@]}"
  "${firewall_list[@]}"
  "${network_list[@]}"
  "${drivers_list[@]}"
  "${codecs_list[@]}"
  "${packages_list[@]}"
  "${extra_packages[@]}"
  "${assets_list[@]}"
  "${programs_list[@]}"
)

install_yay ${list[@]}
