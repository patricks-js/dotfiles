#!/bin/bash
#|---/ /+-------------------------------------+---/ /|#
#|--/ /-| Script to apply pre install configs |--/ /-|#
#|-/ /--| Prasanth Rangan                     |-/ /--|#
#|/ /---+-------------------------------------+/ /---|#

# CLONE_DIR=$HOME/dotfiles

# sddm
if pkg_installed sddm; then

  echo -e "\033[0;32m[DISPLAYMANAGER]\033[0m detected // sddm"
  if [ ! -d /etc/sddm.conf.d ]; then
    sudo mkdir -p /etc/sddm.conf.d
  fi

  if [ ! -f /etc/sddm.conf.d/kde_settings.t2.bkp ]; then
    echo -e "\033[0;32m[DISPLAYMANAGER]\033[0m configuring sddm..."

    sddmtheme="Candy"

    sudo tar -xzf "$HOME"/dotfiles/zip/Sddm_${sddmtheme}.tar.gz -C /usr/share/sddm/themes/
    sudo touch /etc/sddm.conf.d/kde_settings.conf
    sudo cp /etc/sddm.conf.d/kde_settings.conf /etc/sddm.conf.d/kde_settings.t2.bkp
    sudo cp /usr/share/sddm/themes/${sddmtheme}/kde_settings.conf /etc/sddm.conf.d/
  else
    echo -e "\033[0;33m[SKIP]\033[0m sddm is already configured..."
  fi

  if [ ! -f /usr/share/sddm/faces/"${USER}".face.icon ] && [ -f "$HOME"/dotfiles/misc/"${USER}".face.icon ]; then
    sudo cp "$HOME"/dotfiles/misc/"${USER}".face.icon /usr/share/sddm/faces/
    echo -e "\033[0;32m[DISPLAYMANAGER]\033[0m avatar set for ${USER}..."
  fi

else
  echo -e "\033[0;33m[WARNING]\033[0m sddm is not installed..."
fi

# dolphin
if pkg_installed dolphin && pkg_installed xdg-utils; then

  echo -e "\033[0;32m[FILEMANAGER]\033[0m detected // dolphin"
  xdg-mime default org.kde.dolphin.desktop inode/directory
  echo -e "\033[0;32m[FILEMANAGER]\033[0m setting" "$(xdg-mime query default "inode/directory")" "as default file explorer..."

else
  echo -e "\033[0;33m[WARNING]\033[0m dolphin is not installed..."
fi
