#!/bin/bash

# ------------------------------------------------------
# * Check .config folder
# ------------------------------------------------------

if [ -d ~/.config ]; then
    echo -e "\033[0;33m[SKIP]\033[0m $HOME/.config folder already exists."
else
    mkdir ~/.config
    echo -e "\033[0;32m[BOOTLOADER]\033[0m $HOME/.config folder created."
fi

# ------------------------------------------------------
# * Pacman conf setup
# ------------------------------------------------------

if [ -f /etc/pacman.conf ] && [ ! -f /etc/pacman.conf.t2.bkp ]; then
  echo -e "\033[0;32m[PACMAN]\033[0m adding extra spice to pacman..."

  sudo cp /etc/pacman.conf /etc/pacman.conf.t2.bkp
  sudo sed -i "/^#Color/c\Color\nILoveCandy
    /^#VerbosePkgLists/c\VerbosePkgLists
    /^#ParallelDownloads/c\ParallelDownloads = 7" /etc/pacman.conf
  sudo sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf

  sudo pacman -Syyu
  sudo pacman -Fy

else
  echo -e "\033[0;33m[SKIP]\033[0m pacman is already configured..."
fi

# ------------------------------------------------------
# * Grub setup
# ------------------------------------------------------

if [ ! -f /etc/default/grub.t2.bkp ] && [ ! -f /boot/grub/grub.t2.bkp ]; then
  echo -e "\033[0;32m[BOOTLOADER]\033[0m configuring grub..."
  sudo cp /etc/default/grub /etc/default/grub.t2.bkp
  sudo cp /boot/grub/grub.cfg /boot/grub/grub.t2.bkp

  repository="https://github.com/catppuccin/grub.git"
  grubtheme="catppuccin-mocha-grub-theme"

  echo -e "\033[0;32m[BOOTLOADER]\033[0m Setting grub theme"

  git clone "$repository" && cd "grub" || return

  sudo cp -r src/* "/usr/share/grub/themes/"

  sudo sed -i "/^GRUB_DEFAULT=/c\GRUB_DEFAULT=saved
        /^GRUB_THEME=/c\GRUB_THEME=\"/usr/share/grub/themes/${grubtheme}/theme.txt\"
        /^#GRUB_THEME=/c\GRUB_THEME=\"/usr/share/grub/themes/${grubtheme}/theme.txt\"
        /^#GRUB_SAVEDEFAULT=true/c\GRUB_SAVEDEFAULT=true" /etc/default/grub

  sudo grub-mkconfig -o /boot/grub/grub.cfg
  sudo grub-mkconfig -o /boot/efi/EFI/arch/grub.cfg
else
  echo -e "\033[0;33m[SKIP]\033[0m grub is already configured..."
fi
