# ------------------------------------------------------
# * Install some required packages
# ------------------------------------------------------

# Synchronize packages
sudo pacman -Syyuu
echo

# Check for required packages
echo "Checking that required packages for the installation are installed..."
if ! pkg_installed "gum" || ! pkg_installed "figlet"; then
  install_packages_pacman "gum" "figlet";
fi
echo