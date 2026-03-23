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
  kitty
  wl-clipboard
  qt5-wayland
  qt6-wayland
  pamixer
  xdg-user-dirs
  udiskie
  brightnessctl
  xdg-desktop-portal
  waybar
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
  impala
  bluetui
  mako
  gum
  xdg-terminal-exec
  wiremix
  gpu-screen-recorder
  openvpn
  ufw
  pacman-contrib
  wl-clip-persist
  unzip
  zip
  neovim
  imagemagick
  jq
  lsd
  starship
  cliphist
  fzf
  zoxide
  bat
  zellij
)

pkgs_fonts=(
  ttf-cascadia-code-nerd
  ttf-cascadia-mono-nerd
  ttf-jetbrains-mono-nerd
  ttf-firacode-nerd
)

install_list() {
  local label="$1"
  shift
  echo -e "\n:: Instalando $label..."
  paru -S --needed --noconfirm "$@" || echo "!! Alguns pacotes de '$label' falharam"
}

install_curl() {
  local label="$1"
  local cmd="$2"
  echo -e "\n:: Instalando $label..."
  bash -c "$cmd" || echo "!! Falha ao instalar $label"
}

echo ":: Iniciando instalação de pacotes..."

install_list "Core"      "${pkgs_core[@]}"
install_list "Interface" "${pkgs_interface[@]}"
#install_list "Apps"      "${pkgs_apps[@]}"
install_list "Tools"     "${pkgs_tools[@]}"
install_list "Fonts"     "${pkgs_fonts[@]}"

#install_curl "Bun"       "curl -fsSL https://bun.sh/install | bash"
#install_curl "Zed"       "curl -f https://zed.dev/install.sh | sh"
#install_curl "Homebrew"  '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

echo -e "\nPacotes foram processados com sucesso!"
