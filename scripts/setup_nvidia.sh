#!/usr/bin/env bash

echo "options nvidia_drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf >/dev/null

MKINITCPIO_CONF="/etc/mkinitcpio.conf"
# backup
sudo cp "$MKINITCPIO_CONF" "${MKINITCPIO_CONF}.backup-$(date +%s)"

# Remove entradas antigas (cuidado: sed usado abaixo assume sintaxe padrão)
sudo sed -i -E 's/ nvidia_drm//g; s/ nvidia_uvm//g; s/ nvidia_modeset//g; s/ nvidia//g;' "$MKINITCPIO_CONF"

# Adiciona os módulos ao início do array MODULES
action_sed="s/^(MODULES=\()/\1nvidia nvidia_modeset nvidia_uvm nvidia_drm /"
# Executa com sudo (usando perl pra compatibilidade de sed entre shells)
sudo perl -0777 -pe "s/MODULES=\(([^)]*)\)/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm \1)/s" -i "$MKINITCPIO_CONF"

# Gerar initramfs
sudo mkinitcpio -P
