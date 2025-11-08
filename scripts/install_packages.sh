#!/usr/bin/env bash

set -euo pipefail

# Caminho base do repositório (raiz dos dotfiles)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PKG_DIR="$DOTFILES_DIR/packages"

install_with_pacman() {
  local pkg="$1"
  if pacman -Qi "$pkg" &>/dev/null; then
    echo "   -> $pkg já instalado (pacman)."
  else
    echo "   -> Instalando $pkg com pacman..."
    sudo pacman -S --needed --noconfirm "$pkg" &>/dev/null || {
      echo "   !! Falha ao instalar $pkg (pacman)"
    }
  fi
}

install_with_yay() {
  local pkg="$1"
  if pacman -Qi "$pkg" &>/dev/null; then
    echo "   -> $pkg já instalado (yay/pacman)."
  else
    echo "   -> Instalando $pkg com yay..."
    yay -S --needed --noconfirm "$pkg" &>/dev/null || {
      echo "   !! Falha ao instalar $pkg (yay)"
    }
  fi
}

process_file() {
  local file="$1"
  local installer="$2"
  echo -e "\n:: Processando ${file##*/}..."

  while IFS= read -r pkg; do
    pkg="${pkg%%#*}"              # remove comentários após '#'
    pkg="$(echo "$pkg" | xargs)"  # remove espaços extras
    [[ -z "$pkg" ]] && continue
    $installer "$pkg"
  done < "$file"
}

echo ":: Iniciando instalação de pacotes..."
echo ":: Diretório de pacotes: $PKG_DIR"

if [[ -f "$PKG_DIR/core.md" ]]; then
  process_file "$PKG_DIR/core.md" install_with_pacman
fi

if [[ -f "$PKG_DIR/hyprland.md" ]]; then
  process_file "$PKG_DIR/hyprland.md" install_with_yay
fi

echo -e "\nPacotes foram processados com sucesso!"
