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

cp lists/_base.lst package.lst

./install.sh package.lst
rm package.lst

#./font.sh lists/_fonts.lst
#./theme.sh lists/_themes.lst
#./zsh.sh lists/_zsh_plugins.lst
#./config.sh lists/_configs.lst
#./etc.sh

#while read srv; do
#  if [[ $(systemctl list-units --all -t service --full --no-legend "${srv}.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "${srv}.service" ]]; then
#    echo "$srv service is already enabled, enjoy..."
#  else
#    echo "$srv service is not enabled, enabling..."
#    sudo systemctl enable ${srv}.service
#    if [[ "$srv" != "nvidia-suspend" && "$srv" != "nvidia-hibernate" && "$srv" != "nvidia-resume" ]]; then
#      sudo systemctl start ${srv}.service
#      echo "$srv service enabled and started..."
#    fi
#  fi
#done < <(cut -d '#' -f 1 lists/_system.lst)
