#!/usr/bin/env bash

system_tools=(
    "networkmanager"
    "network-manager-applet"
    "rustup"
    "bluez"
    "bluez-utils"
    "sddm"
    "qt6-svg"
    "qt6-declarative"
    "pacman-contrib"
    "parallel"
    "jq"
    "wl-clipboard"
    "brightnessctl"
    "wget"
    "zip"
    "unzip"
    "ufw"
    "ufw-extras"
    "openssh"
    "mesa"
    "xdg-user-dirs"
    "libva-intel-driver"
    "intel-media-driver"
    "vulkan-intel"
)

multimedia_apps=(
    "pipewire"
    "pipewire-alsa"
    "pipewire-audio"
    "pipewire-jack"
    "pipewire-pulse"
    "gst-plugin-pipewire"
    "wireplumber"
    "ffmpeg"
    "libjpeg-turbo"
    "libpng"
    "libwebp"
    "imagemagick"
    "ffmpeg"
    "noto-fonts"
    "noto-fonts-cjk"
    "noto-fonts-emoji"
    "papirus-icon-theme"
    "bibata-cursor-theme-bin"
    "ttf-jetbrains-mono-nerd"
    "ttf-material-design-icons-extended"
)

utils=(
    "zoxide"
    "cava"
    "btop"
    "lsd"
    "starship"
    "stow"
    "neofetch"
    "tokei"
    "fzf"
    "bat"
    "git-crypt"
)

gnome=(
    "gnome"
    "gnome-tweaks"
    "gnome-boxes"
    "pika-backup"
    "ulauncher"
)

install_app() {
    local app_name="$1"

    if pacman -Qs "$app_name" >/dev/null 2>&1; then
        echo "Info: $app_name is already installed."
    elif yay -Ss "$app_name" >/dev/null 2>&1; then
        echo "Info: Installing $app_name."
        yay -S "$app_name"
    else
        echo "Error: $app_name not found in Arch repositories or AUR."
    fi
}

for app in "${system_tools[@]}"; do
    install_app "$app"
done;

for app in "${multimedia_apps[@]}"; do
    install_app "$app"
done;

for app in "${utils[@]}"; do
    install_app "$app"
done;

for app in "${gnome[@]}"; do
    install_app "$app"
done;
