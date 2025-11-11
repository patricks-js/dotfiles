#!/usr/bin/env bash

count=$(checkupdates 2>/dev/null | wc -l)
aur=$(yay -Qum 2>/dev/null | wc -l)
total=$((count + aur))

if [[ $total -gt 0 ]]; then
  echo "{\"icon\": \"󰏗\", \"count\": \"$total\"}"
else
  echo ""
fi
