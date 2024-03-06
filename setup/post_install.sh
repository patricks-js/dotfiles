#!/bin/bash

# sddm
if [ ! -d /etc/sddm.conf.d ]; then
  sudo mkdir -p /etc/sddm.conf.d
fi

if [ ! -f /etc/sddm.conf.d/theme.t2.bkp ]; then
  echo -e "\033[0;32m[DISPLAYMANAGER]\033[0m configuring sddm..."

  repository="https://github.com/catppuccin/sddm.git"
  sddmtheme="catppuccin-mocha"

  git clone $repository && cd "sddm/src"

  sudo cp -r "${sddmtheme}" /usr/share/sddm/themes
  sudo touch /etc/sddm.conf.d/theme.conf
  sudo echo "[Theme]" >> /etc/sddm.conf.d/theme.conf
  sudo echo "Current=${sddmtheme}" >> /etc/sddm.conf.d/theme.conf
else
  echo -e "\033[0;33m[SKIP]\033[0m sddm is already configured..."
fi

# fisher
fiher_plugin="jorgebucaran/fisher"
install_fisher=https://raw.githubusercontent.com/${fiher_plugin}/main/functions/fisher.fish

curl -sL "$install_fisher" | source && fisher install $fiher_plugin
fisher install catppuccin/fish
fish_config theme save "Catppuccin Mocha"

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source ~/.config/tmux/tmux.conf

# kvm
echo "START KVM/QEMU/VIRT MANAGER INSTALLATION..."

sudo pacman -S virt-manager virt-viewer qemu vde2 ebtables iptables-nft nftables dnsmasq bridge-utils ovmf swtpm

echo "Modifying /etc/libvirt/libvirtd.conf..."
sudo sed -i '/^#unix_sock_group = "libvirt"/s/^#//' /etc/libvirt/libvirtd.conf
sudo sed -i '/^#unix_sock_rw_perms = "0770"/s/^#//' /etc/libvirt/libvirtd.conf

sudo echo 'log_filters="3:qemu 1:libvirt"' >> /etc/libvirt/libvirtd.conf
sudo echo 'log_outputs="2:file:/var/log/libvirt/libvirtd.log"' >> /etc/libvirt/libvirtd.conf

sudo usermod -a -G kvm,libvirt $(whoami)

sudo systemctl enable libvirtd
sudo systemctl start libvirtd

echo "Modifying /etc/libvirt/qemu.conf..."
sudo sed -i '/^#user = "patrick"/s/^#//' /etc/libvirt/qemu.conf
sudo sed -i '/^#group = "patrick"/s/^#//' /etc/libvirt/qemu.conf

sudo systemctl restart libvirtd

sudo virsh net-autostart default

echo "Configuration completed."
