#!/bin/bash

#|---/ /+--------------------------+---/ /|#
#|--/ /-| Enabling services        |--/ /-|#
#|-/ /--| @_patrick.js             |-/ /--|#
#|/ /---+--------------------------+/ /---|#

# ------------------------------------------------------
# ? Enable system services
# ------------------------------------------------------

system_services_lst=(
  "NetworkManager"
  "bluetooth"
  "sddm"
  "sshd"
  "ufw"
  "polkit"
)

for service in "${system_services_lst[@]}"; do
  system_service_ctl "$service"
done

# ------------------------------------------------------
# ? Enable user services
# ------------------------------------------------------

user_services_lst=(
  "pipewire"
  "pipewire-pulse"
  "wireplumber"
)

for service in "${user_services_lst[@]}"; do
  user_service_ctl "$service"
done
