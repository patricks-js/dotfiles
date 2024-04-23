#!/usr/bin/env bash

# ------------------------------------------------------
# * SDDM Theme setup
# ------------------------------------------------------

if pacman -Qi "sddm" &> /dev/null; then
    echo -e "\033[0;32m[DISPLAYMANAGER]\033[0m detected // sddm"
    if [ ! -d /etc/sddm.conf.d ]; then
        sudo mkdir -p /etc/sddm.conf.d
    fi

    if [ ! -f /etc/sddm.conf.d/theme.t2.bkp ]; then
        echo -e "\033[0;32m[DISPLAYMANAGER]\033[0m configuring sddm..."

        sddm_theme="catppuccin-mocha"

        wget -P ~/Downloads/ https://github.com/catppuccin/sddm/releases/download/v1.0.0/$sddm_theme.zip
        sudo unzip -o ~/Downloads/$sddm_theme.zip -d /usr/share/sddm/themes/

        sudo touch /etc/sddm.conf.d/theme.conf
        sudo cp /etc/sddm.conf.d/theme.conf /etc/sddm.conf.d/theme.t2.bkp
        echo -e "[Theme]\nCurrent=$sddm_theme" | sudo tee /etc/sddm.conf.d/theme.conf
    else
        echo -e "\033[0;33m[SKIP]\033[0m sddm is already configured..."
    fi
else
    echo -e "\033[0;33m[WARNING]\033[0m sddm is not installed..."
fi
