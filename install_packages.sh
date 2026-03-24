#!/usr/bin/env bash

set -euo pipefail

pkgs_apps=(
  kitty
  obsidian
  zen-browser-bin
)

pkgs_tools=(
  openvpn
  unzip
  zip
  neovim
  wl-clipboard
  lsd
  starship
  fzf
  zoxide
  bat
  btop
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

install_list "Apps"      "${pkgs_apps[@]}"
install_list "Tools"     "${pkgs_tools[@]}"
install_list "Fonts"     "${pkgs_fonts[@]}"

install_curl "Bun"       "curl -fsSL https://bun.sh/install | bash"
install_curl "Zed"       "curl -f https://zed.dev/install.sh | sh"
install_curl "Homebrew"  '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

echo -e "\nPacotes foram processados com sucesso!"
