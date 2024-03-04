#!/bin/bash

setup_fish() {
  local install_fisher=https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish

  if ! yay -Qi fish &>/dev/null; then
    curl -sL "$install_fisher" | source && fisher install jorgebucaran/fisher
    fisher install catppuccin/fish
    fish_config theme save "Catppuccin Mocha"
  fi
}

setup_tmux() {
  if ! yay -Qi tmux &>/dev/null; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    tmux source ~/.config/tmux/tmux.conf
  fi
}

setup_fish
setup_tmux
