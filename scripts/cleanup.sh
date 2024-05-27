#!/usr/bin/env bash

# Check for running NetworkManager.service
if [[ $(systemctl list-units --all -t service --full --no-legend "NetworkManager.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "NetworkManager.service" ]];then
    echo ":: NetworkManager.service already running."
else
    sudo systemctl enable NetworkManager.service
    sudo systemctl start NetworkManager.service
    echo ":: NetworkManager.service activated successfully."    
fi

# Check for running bluetooth.service
if [[ $(systemctl list-units --all -t service --full --no-legend "bluetooth.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "bluetooth.service" ]];then
    echo ":: bluetooth.service already running."
else
    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service
    echo ":: bluetooth.service activated successfully."    
fi

# Check for running ufw.service
if [[ $(systemctl list-units --all -t service --full --no-legend "ufw.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "ufw.service" ]];then
    echo ":: ufw.service already running."
else
    sudo systemctl enable ufw.service
    sudo systemctl start ufw.service
    echo ":: ufw.service activated successfully."    
fi

# Check for running sshd.service
if [[ $(systemctl list-units --all -t service --full --no-legend "sshd.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "sshd.service" ]];then
    echo ":: sshd.service already running."
else
    sudo systemctl enable sshd.service
    sudo systemctl start sshd.service
    echo ":: sshd.service activated successfully."    
fi

# Check for running sddm.service
if [[ $(systemctl list-units --all -t service --full --no-legend "sddm.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "sddm.service" ]];then
    echo ":: sddm.service already running."
else
    sudo systemctl enable sddm.service
    sudo systemctl start sddm.service
    echo ":: sddm.service activated successfully."    
fi

if [ -d ~/dotfiles/hypr/settings/ ] ;then
    rm -rf ~/dotfiles/hypr/settings
    echo ":: ~/dotfiles/hypr/settings removed."
fi

# Create default folder structure
xdg-user-dirs-update
echo 

echo ":: Cleanup done."
