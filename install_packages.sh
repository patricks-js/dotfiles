#!/usr/bin/env bash

set -euo pipefail

pkgs_system=(
  kitty wl-clipboard
  openvpn v4l2loopback-dkms
  downgrade
)

pkgs_appearance=(
  bibata-cursor-theme-bin
  papirus-icon-theme
)

pkgs_terminal=(
  neovim zellij starship
  lsd fzf zoxide bat jq
  unzip zip tar
  imagemagick stow
)

pkgs_fonts=(
  ttf-cascadia-code-nerd
  ttf-jetbrains-mono-nerd
  ttf-firacode-nerd
)

pkgs_apps=(
  zen-browser-bin helium-browser-bin
  obsidian discord
  obs-studio gpu-screen-recorder
  jetbrains-toolbox
  bruno-bin beekeeper-studio-bin
  hydra-launcher-bin
)

install_list() {
  local label="$1"; shift
  echo -e "\n\e[1;34m::\e[0m Installing $label..."
  paru -S --needed --noconfirm "$@" || echo -e "\e[1;31m!!\e[0m Some packages from '$label' failed to install"
}

install_curl() {
  local label="$1"; local cmd="$2"
  echo -e "\n\e[1;34m::\e[0m Installing $label via Script..."
  eval "$cmd" || echo -e "\e[1;31m!!\e[0m Failed to install $label"
}

echo ":: Starting setup installation..."

install_list "Sistema"   "${pkgs_system[@]}"
install_list "Appearance" "${pkgs_appearance[@]}"
install_list "Terminal"  "${pkgs_terminal[@]}"
install_list "Fonts"     "${pkgs_fonts[@]}"
install_list "Apps"    "${pkgs_apps[@]}"

install_curl "Bun"       "curl -fsSL https://bun.sh/install | bash"
install_curl "Zed"       "curl -f https://zed.dev/install.sh | sh"
install_curl "Homebrew" '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

echo -e "\n\e[1;34m::\e[0m Cleaning up default config files to avoid stow conflicts..."
rm -f  "$HOME/.config/fish/config.fish"
rm -rf "$HOME/.config/fastfetch"
rm -rf "$HOME/.config/kitty"

echo -e "\n\e[1;34m::\e[0m Running stow to symlink dotfiles..."
stow --dir="$(cd "$(dirname "$0")" && pwd)" --target="$HOME" .

echo -e "\n\e[1;32mSetup completed successfully!\e[0m"
