#!/bin/bash
#|---/ /+--------------------------+---/ /|#
#|--/ /-| Main installation script |--/ /-|#
#|-/ /--| @_patrick.js             |-/ /--|#
#|/ /---+--------------------------+/ /---|#

source ./utils/message.sh

banner_msg "Arch + Hyprland"

#----------------------------------#
# * Import variables and functions #
#----------------------------------#

source ./utils/functions.sh
unable_source_fn

#----------------------#
# * Pre-install script #
#----------------------#

banner_msg "Pre install"

source ./pre_install.sh
source ./yay.sh

#--------------#
# * Installing #
#--------------#

banner_msg "Installing"

source ./utils/install_drivers.sh
source ./utils/install_packages.sh
source ./utils/install_programs.sh

#-----------------------#
# * Post-install script #
#-----------------------#

banner_msg "Post install"

source ./pst_install.sh

#--------------------------#
# * Enable system services #
#--------------------------#

banner_msg "Services"

source ./utils/enable_services.sh
