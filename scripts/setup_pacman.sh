#!/usr/bin/env bash

if [ -d ~/.config ]; then
	echo -e "$HOME/.config folder already exists."
else
	mkdir -p ~/.config
	echo -e "$HOME/.config folder created."
fi

if [ -f /etc/pacman.conf ] && [ ! -f /etc/pacman.conf.bkp ]; then
	echo -e "adding extra spice to pacman..."

	sudo cp /etc/pacman.conf /etc/pacman.conf.bkp
	sudo sed -i "/^#Color/c\Color\nILoveCandy
    /^#VerbosePkgLists/c\VerbosePkgLists
    /^#ParallelDownloads/c\ParallelDownloads = 10" /etc/pacman.conf

	sudo pacman -Syyu
	sudo pacman -Fy
else
	echo -e "pacman is already configured..."
fi
