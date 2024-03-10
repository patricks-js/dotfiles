#!/bin/bash

# fisher
fiher_plugin="jorgebucaran/fisher"
install_fisher=https://raw.githubusercontent.com/${fiher_plugin}/main/functions/fisher.fish

curl -sL "$install_fisher" | source && fisher install $fiher_plugin
fisher install catppuccin/fish
fish_config theme save "Catppuccin Mocha"

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source ~/.config/tmux/tmux.conf
