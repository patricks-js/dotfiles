#!/usr/bin/env bash

count=$(checkupdates 2>/dev/null | wc -l)
aur=$(yay -Qum 2>/dev/null | wc -l)
total=$((count + aur))

if (( total > 0 )); then
  echo "Arch update available"
  exit 0
else
  echo "Arch is up to date"
  exit 1
fi
