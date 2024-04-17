#!/usr/bin/env bash

# ------------------------------------------------------
# * Restore dotfiles
# ------------------------------------------------------

# Remove some configs in ~/.config/*
if [ -d "$HOME/.config" ]; then
  rm -rf "$HOME/.config/cava"
  rm -rf "$HOME/.config/fish"
  rm -rf "$HOME/.config/gtk-4.0"
  rm -rf "$HOME/.config/kitty"
  rm -rf "$HOME/.config/lsd"
  rm -rf "$HOME/.config/neofetch"
  rm -rf "$HOME/.config/tmux"
  rm -rf "$HOME/.config/starship.toml"
  echo "Info: Done. Dotfiles restored."
else
  echo "Warning: ~/.config not found."
fi

# Change directory to ~/dotfiles and run `stow .`
if [ -d "$HOME/dotfiles" ]; then
  cd "$HOME/dotfiles"
  stow .
  echo "Info: ~/dotfiles restored using stow."

  yay -S gitflow-avh gitflow-fishcompletion-avh
else
  echo "Error: ~/dotfiles not found."
fi