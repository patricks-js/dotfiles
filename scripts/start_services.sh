#!/usr/bin/env bash

set -euo pipefail

echo ":: Starting essential services..."

# -----------------------------
# System services
# -----------------------------
SYSTEM_SERVICES=(
  iwd
  bluetooth
  ufw
  sshd
  sddm
)

for svc in "${SYSTEM_SERVICES[@]}"; do
  if systemctl --no-pager --quiet is-active "${svc}.service"; then
    echo ":: ${svc}.service already running."
  else
    echo ":: Activating ${svc}.service..."
    sudo systemctl --no-pager --quiet enable --now "${svc}.service" || {
      echo "!! Failed to start ${svc}.service. Check logs below:"
      sudo journalctl -u "${svc}.service" -b --no-pager -n 15
    }
    echo ":: ${svc}.service activated successfully."
  fi
done

# -----------------------------
# User services
# -----------------------------
USER_SERVICES=(
  pipewire
  pipewire-pulse
  wireplumber
)

for svc in "${USER_SERVICES[@]}"; do
  if systemctl --user --no-pager --quiet is-active "${svc}.service"; then
    echo ":: ${svc}.service already running."
  else
    echo ":: Activating ${svc}.service (user)..."
    systemctl --user --no-pager --quiet enable --now "${svc}.service" || {
      echo "!! Failed to start ${svc}.service (user). Check logs below:"
      journalctl --user -u "${svc}.service" -b --no-pager -n 15
    }
    echo ":: ${svc}.service activated successfully (user)."
  fi
done

# -----------------------------
# Misc setup
# -----------------------------
xdg-user-dirs-update
echo ":: XDG directories ensured."

echo -e "\n:: All essential services are up and running."
