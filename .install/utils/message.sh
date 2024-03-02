#!/usr/bin/env bash
#|---/ /+--------------------------+---/ /|#
#|--/ /-| Messages                 |--/ /-|#
#|-/ /--| @_patrick.js             |-/ /--|#
#|/ /---+--------------------------+/ /---|#

RED='\033[0;31m'    #'0;31' is Red
YELLOW='\033[1;32m' #'1;32' is Yellow
BLUE='\033[0;34m'   #'0;34' is Blue
NONE='\033[0m'      # RESET COLOR

check_figlet() {
  if pacman -Qi "figlet" &>/dev/null; then
    return 0
  else
    sudo pacman -S figlet
  fi
}

error_msg() {
  local msg=$1

  echo -e "${RED}"
  echo "Error: ${msg}"
  echo -e "${NONE}"

  return 0
}

success_msg() {
  local msg=$1

  echo -e "${BLUE}"
  echo "${msg}"
  echo -e "${NONE}"

  return 0
}

banner_msg() {
  check_figlet

  local msg=$1

  echo -e "${YELLOW}"
  figlet -c "${msg}"
  echo -e "${NONE}"

  return 0
}

unable_source_fn() {
  if [ $? -ne 0 ]; then
    error_msg "Error: unable to source functions.sh in $(dirname "$(realpath "$0")")..."
    exit 1
  fi
}
