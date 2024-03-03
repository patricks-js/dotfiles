#!/bin/bash
#|---/ /+--------------------------+---/ /|#
#|--/ /-| My common programs       |--/ /-|#
#|-/ /--| @_patrick.js             |-/ /--|#
#|/ /---+--------------------------+/ /---|#

programs_lst=(
  "obsidian"
  "discord"
  "stremio"
  "brave-bin"
  "visual-studio-code-bin"
  "neovim"
  "mpv"
  "obs-studio"
  "steam"
  "zoxide"
  "tokei"
  "gamemode"
  "cava"
  "firefox"
  "neofetch"
  "tmux"
  "stow"
  "starship"
  "lsd"
  "flatpak"
  "steam"
)

install_package_yay "${programs_lst[@]}"
