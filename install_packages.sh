#!/usr/bin/env bash

set -euo pipefail

# 1. Base do Ecossistema Hyprland & Wayland
pkgs_core=(
  hyprland hyprlock hyprpaper hypridle hyprsunset hyprpolkitagent
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal
  uwsm # Gerenciador de sessão
  waybar mako # Barra e Notificações (mako saiu de tools para cá)
  sddm kitty wl-clipboard wl-clip-persist cliphist
  qt5-wayland qt6-wayland
)

# 2. Hardware, Rede e Sistema (O que roda "por baixo")
pkgs_system=(
  udiskie brightnessctl pamixer wiremix
  bluez bluetui # Bluetooth
  impala # Wi-Fi TUI
  openvpn ufw
  v4l2loopback-dkms
  pacman-contrib downgrade
  gvfs thunar-volman # Suporte a montagem de discos
)

# 3. Interface, Temas e File Manager
pkgs_interface=(
  thunar thunar-archive-plugin
  tumbler ffmpegthumbnailer # Thumbnails no Thunar
  nwg-look bibata-cursor-theme-bin papirus-icon-theme
  grimblast-git satty # Screenshot e Edição
)

# 4. Terminal, Shell & CLI Tools (Seu workflow de dev)
pkgs_terminal=(
  neovim zellij starship
  lsd fzf zoxide bat jq gum
  unzip zip tar
  imagemagick
)

# 5. Fontes (Reduzi para as essenciais, mas mantive sua escolha)
pkgs_fonts=(
  ttf-cascadia-code-nerd
  ttf-jetbrains-mono-nerd
  ttf-firacode-nerd
)

# 6. Aplicativos Pesados (Desktop)
pkgs_apps=(
  zen-browser-bin obsidian discord
  obs-studio gpu-screen-recorder
  bruno-bin beekeeper-studio-bin
)

# --- Funções de Instalação ---

install_list() {
  local label="$1"; shift
  echo -e "\n\e[1;34m::\e[0m Instalando $label..."
  paru -S --needed --noconfirm "$@" || echo -e "\e[1;31m!!\e[0m Alguns pacotes de '$label' falharam"
}

install_curl() {
  local label="$1"; local cmd="$2"
  echo -e "\n\e[1;34m::\e[0m Instalando $label via Script..."
  eval "$cmd" || echo -e "\e[1;31m!!\e[0m Falha ao instalar $label"
}

# --- Execução ---

echo ":: Iniciando instalação de setup Hyprland..."

install_list "Core"      "${pkgs_core[@]}"
install_list "Sistema"   "${pkgs_system[@]}"
install_list "Interface" "${pkgs_interface[@]}"
install_list "Terminal"  "${pkgs_terminal[@]}"
install_list "Fonts"     "${pkgs_fonts[@]}"
install_list "Apps"    "${pkgs_apps[@]}"

install_curl "Bun"       "curl -fsSL https://bun.sh/install | bash"
install_curl "Zed"       "curl -f https://zed.dev/install.sh | sh"
install_curl "Homebrew" '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

echo -e "\n\e[1;32mSetup finalizado com sucesso!\e[0m"
