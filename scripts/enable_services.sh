#!/usr/bin/env bash

user_services=(
  "pipewire"
  "pipewire-pulse"
  "wireplumber"
)

system_services=(
  "NetworkManager"
  "sshd"
  "ufw"
  "bluetooth"
)

# ------------------------------------------------------
# * Enable system services
# ------------------------------------------------------

for s in "${system_services[@]}"; do
    if [[ $(systemctl list-units --all -t service --full --no-legend "${s}.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "${s}.service" ]]; then
        echo -e "\033[0;33m[SKIP]\033[0m ${s} service is active..."
    else
        echo -e "\033[0;32m[systemctl]\033[0m starting ${s} system service..."
        sudo systemctl enable "${s}"
        sudo systemctl start "${s}"
    fi
done

# ------------------------------------------------------
# * Enable user services
# ------------------------------------------------------

for s in "${user_services[@]}"; do
    if [[ $(systemctl --user list-units --all -t service --full --no-legend "${s}.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "${s}.service" ]]; then
        echo -e "\033[0;33m[SKIP]\033[0m ${s} service is active..."
    else
        echo -e "\033[0;32m[systemctl]\033[0m starting ${s} user service..."
        sudo systemctl --user enable "$s"
        sudo systemctl --user start "$s"
    fi
done
