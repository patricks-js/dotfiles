#!/bin/bash

if pgrep -x openvpn >/dev/null; then
  echo '{"text": "󰌾", "tooltip": "VPN connected"}'
else
  echo '{"text": ""}'
fi
