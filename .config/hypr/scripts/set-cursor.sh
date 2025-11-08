#!/usr/bin/env bash

set -euo pipefail

THEME="${HYPRCURSOR_THEME:-Bibata-Modern-Ice}"

# GTK
if command -v gsettings &>/dev/null; then
  gsettings set org.gnome.desktop.interface cursor-theme "$THEME" || true
fi

SYS_ICONS="/usr/share/icons/${THEME}"
USR_ICONS="${HOME}/.icons/${THEME}"

# Garante que o tema exista localmente (Flatpak acessa ~/.icons)
if [[ ! -d "$USR_ICONS" ]]; then
  if [[ -d "$SYS_ICONS" ]]; then
    mkdir -p ~/.icons
    cp -r "$SYS_ICONS" ~/.icons/
  else
    echo "!! Tema ${THEME} não encontrado nem em /usr/share/icons nem em ~/.icons"
    exit 1
  fi
fi

# Flatpak
if command -v flatpak &>/dev/null; then
  if ! flatpak info --show-permissions | grep -q "\.icons"; then
    flatpak override --user --filesystem=~/.themes:ro --filesystem=~/.icons:ro >/dev/null 2>&1 || true
  fi
fi
