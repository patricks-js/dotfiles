#!/bin/bash

enable_service() {
	local service=$1

	if systemctl is-active -q "$service"; then
		echo "$service is already activated."
		return 0
	fi

	echo "Enabling $service ..."
	sudo systemctl enable "$service.service"
	sudo systemctl start "$service.service"
	echo "$service enabled and is running."

	return 0
}

enable_user_service() {
	local service=$1

	if systemctl --user is-active -q "$service"; then
		echo "$service is already activated."
		return 0
	fi

	echo "Enabling $service ..."
	sudo systemctl --user enable "$service.service"
	sudo systemctl --user start "$service.service"
	echo "$service enabled and is running."

	return 0
}

# ------------------------------------------------------
# ? Enabling system services
# ------------------------------------------------------

services_list=(
	"NetworkManager"
	"sshd"
	"ufw"
	"bluetooth"
	"sddm"
	"polkit"
)

for s in "${services_list[@]}"; do
	enable_service $s
done

# ------------------------------------------------------
# ? Enabling user services
# ------------------------------------------------------

user_services_list=(
	"pipewire"
	"pipewire-pulse"
	"wireplumber"
)

for s in "${user_services_list[@]}"; do
	enable_user_service $s
done
