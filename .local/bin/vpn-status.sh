#!/usr/bin/env bash

if nmcli connection show --active | grep -qi "vpn"; then
  NAME=$(nmcli connection show --active | grep vpn | awk '{print $1}')
  echo "{\"icon\": \"🛡️\", \"tooltip\": \"VPN ativa: $NAME\"}"
else
  echo ""
fi
