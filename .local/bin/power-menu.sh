#!/usr/bin/env bash

# Ícones (usando Nerd Font, opcional)
options="  Desligar\n󰤄  Reiniciar\n󰌾  Suspender\n󰗽  Hibernar\n󰍃  Logout\n󰜉  Cancelar"

chosen=$(echo -e "$options" | rofi -dmenu -p "Power" -theme-str 'window {width: 20%;}')

case "$chosen" in
    *Desligar) systemctl poweroff ;;
    *Reiniciar) systemctl reboot ;;
    *Suspender) systemctl suspend ;;
    *Hibernar) systemctl hibernate ;;
    *Logout) hyprctl dispatch exit ;;
    *Cancelar) exit 0 ;;
esac
