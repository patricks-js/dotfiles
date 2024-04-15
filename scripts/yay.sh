print_banner "Yay"

if ! pacman -Qi "yay" &> /dev/null; then
    echo -e "${BLUE}"
    echo "Installing yay..."
    echo -e "${NONE}"

    pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/yay-bin.git ~/yay-bin
    cd ~/yay-bin || exit
    makepkg -si
    yay -Y --gendb
    yay -Y --devel --save
    yay
    
    echo -e "${GREEN}"
    echo "yay has been installed successfully."
    echo -e "${NONE}"
else
    echo -e "${GREEN}"
    echo -e "\033[0;33m[SKIP]\033[0m yay is already installed."
    echo -e "${NONE}"
fi
