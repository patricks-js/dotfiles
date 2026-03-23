#!/usr/bin/env bash

set -euo pipefail

pkgs_core=(
  hyprland
  hyprlock
  hyprpaper
  hypridle
  hyprsunset
  hyprpolkitagent
  xdg-desktop-portal-hyprland
  xdg-desktop-portal-gtk
  fish
  bluez
  bluez-utils
  kitty
  wl-clipboard
  qt5-wayland
  qt6-wayland
  pamixer
  xdg-user-dirs
  udiskie
  brightnessctl
  xdg-desktop-portal
  quickshell
  sddm
)

pkgs_interface=(
  nwg-look
  thunar
  bibata-cursor-theme-bin
  papirus-icon-theme
  grimblast-git
  satty
)

pkgs_apps=(
  visual-studio-code-bin
  obsidian
  zen-browser-bin
)

pkgs_tools=(
  thunar-archive-plugin
  thunar-volman
  gvfs
  tumbler
  ffmpegthumbnailer
  uwsm
  tar
  openvpn
  networkmanager-openvpn
  ufw
  pacman-contrib
  unzip
  zip
  neovim
  imagemagick
  jq
  lsd
  starship
  fastfetch
  cliphist
  fzf
  zoxide
  bat
  btop
  zellij
)

pkgs_fonts=(
  noto-fonts
  ttf-cascadia-code-nerd
  ttf-cascadia-mono-nerd
  ttf-jetbrains-mono-nerd
  ttf-firacode-nerd
)

install_list() {
  local label="$1"
  shift
  echo -e "\n:: Instalando $label..."
  yay -S --needed --noconfirm "$@" || echo "!! Alguns pacotes de '$label' falharam"
}

echo ":: Iniciando instalação de pacotes..."

install_list "Core"      "${pkgs_core[@]}"
install_list "Interface" "${pkgs_interface[@]}"
install_list "Apps"      "${pkgs_apps[@]}"
install_list "Tools"     "${pkgs_tools[@]}"
install_list "Fonts"     "${pkgs_fonts[@]}"

echo -e "\nPacotes foram processados com sucesso!"
