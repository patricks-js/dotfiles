#!/bin/bash

if [ -f "/usr/bin/swayidle" ]; then
  echo "swayidle is installed."
  swayidle -w timeout 300 'swaylock -f' timeout 360 'hyprctl dispach dpms off' resume 'hyprctl dispach dpms on'
else
  echo "swayidle not installed."
fi
