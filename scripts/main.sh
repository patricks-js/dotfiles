#!/bin/bash

source utils/functions.sh
clear

# ------------------------------------------------------
# * Setting up
# ------------------------------------------------------

source setup.sh

# Install yay aur helper
source yay.sh

# ------------------------------------------------------
# * Installing and base config
# ------------------------------------------------------

# install packages
source install_pkgs.sh

# install apps
source install_apps.sh

# customize gtk
source gtk.sh

# customize display manager
source sddm.sh

# ------------------------------------------------------
# * Finishing
# ------------------------------------------------------

# enable services and other
source cleanup.sh

# reboot
echo ":: Rebooting now ..."
sleep 3
systemctl reboot
