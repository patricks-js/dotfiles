#!/bin/bash

# ------------------------------------------------------
# * Install apps
# ------------------------------------------------------

apps=(
    "neovim"
    "emote"
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

_installPackagesYay "${apps[@]}";
