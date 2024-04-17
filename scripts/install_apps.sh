#!/usr/bin/env bash

# ------------------------------------------------------
# * Install apps
# ------------------------------------------------------

apps=(
    "neovim"
    "emote"
    "cava"
    "kitty"
    "spotify"
    "obsidian"
    "discord"
    "brave-bin"
    "visual-studio-code-bin"
    "mpv"
    "obs-studio"
    "firefox"
    "stremio"
)

for app in "${apps[@]}"; do
  if pacman -Qs "$app" >/dev/null 2>&1; then
    echo "Info: $app is already installed."
  elif yay -Ss "$app" >/dev/null 2>&1; then
    echo "Info: Installing $app."
    yay -S --noconfirm "$app"
  else
    echo "Error: $app not found in Arch repositories or AUR."
  fi
done;
