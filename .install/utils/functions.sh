#!/bin/bash
#|---/ /+--------------------------+---/ /|#
#|--/ /-| Global functions         |--/ /-|#
#|-/ /--| @_patrick.js             |-/ /--|#
#|/ /---+--------------------------+/ /---|#

set -e

# ------------------------------------------------------
# ? Check if service is running
# ------------------------------------------------------

system_service_ctl() {
  local service_name=$1

  if systemctl is-active -q "$service_name"; then
    echo "Service is already actvated."

    return 0
  else
    echo "Enabling $service_name ..."
    sudo systemctl enable "$service_name".service
    sudo systemctl start "$service_name".service
    echo "$service_name service enabled, and running..."

    return 1
  fi
}

user_service_ctl() {
  local service_name=$1

  if systemctl --user is-active -q "$service_name"; then
    echo "Service is already actvated."

    return 0
  else
    echo "Enabling $service_name ..."
    sudo systemctl --user enable "$service_name".service
    sudo systemctl --user start "$service_name".service
    echo "$service_name service enabled, and running..."

    return 1
  fi
}

# ------------------------------------------------------
# ? Check if package is installed
# ------------------------------------------------------

pkg_installed() {
  local package_name=$1 # First argument, e.g: pkg_installed "spotify"

  if pacman -Qi "$package_name" &>/dev/null; then
    echo "$package_name is already installed."
    return 0
  else
    echo "$package_name is not installed."
    return 1
  fi
}

# ------------------------------------------------------
# ? Check if package is available in AUR or Arch repo
# ------------------------------------------------------

pacman_pkg_available() {
  local package_name=$1

  if pacman -Ss "$package_name"; then
    echo "$package_name is available in arch repository."
    return 0
  else
    echo "$package_name not available in arch repository."
    return 1
  fi
}

aur_pkg_available() {
  local package_name=$1

  if yay -Ss "$package_name"; then
    echo "$package_name available in AUR."
    return 0
  else
    echo "$package_name not available in AUR."
    return 1
  fi
}

# ------------------------------------------------------
# ? Install package with pacman
# ------------------------------------------------------

install_package_pacman() {
  local package=$1

  if pacman_pkg_available "$package" -eq 0; then
    echo "Installing $package..."
    sudo pacman --noconfirm -S "$package"

    success_msg "$package installed."
  fi
}

# ------------------------------------------------------
# ? Install package with yay
# ------------------------------------------------------

install_package_yay() {
  local package=$1

  if aur_pkg_available "$package" -eq 0; then
    echo "Installing $package..."
    yay --noconfirm -S "$package"

    success_msg "$package installed."
  fi
}
