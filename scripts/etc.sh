#!/usr/bin/env bash

source fn.sh

if [ -d ~/.config ]; then
	echo -e "\033[0;33m[SKIP]\033[0m $HOME/.config folder already exists."
else
	mkdir -p ~/.config
	echo -e "\033[0;32m[BOOTLOADER]\033[0m $HOME/.config folder created."
fi

if [ -f /etc/pacman.conf ] && [ ! -f /etc/pacman.conf.t2.bkp ]; then
	echo -e "\033[0;32m[PACMAN]\033[0m adding extra spice to pacman..."

	sudo cp /etc/pacman.conf /etc/pacman.conf.t2.bkp
	sudo sed -i "/^#Color/c\Color\nILoveCandy
    /^#VerbosePkgLists/c\VerbosePkgLists
    /^#ParallelDownloads/c\ParallelDownloads = 10" /etc/pacman.conf
	sudo sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf

	sudo pacman -Syyu
	sudo pacman -Fy
else
	echo -e "\033[0;33m[SKIP]\033[0m pacman is already configured..."
fi

if pkg_installed nemo; then
    gsettings set org.cinnamon.desktop.default-applications.terminal exec kitty && \
    gsettings set org.nemo.preferences.menu-config background-menu-open-as-root false && \
    gsettings set org.nemo.preferences.menu-config selection-menu-open-as-root false && \
    gsettings set org.nemo.preferences thumbnail-limit 10485760

    xdg-mime default nemo.desktop inode/directory
    echo "setting" $(xdg-mime query default "inode/directory") "as default file explorer..."
fi
