#!/usr/bin/env bash

app="$1"

if [ -z "$app" ]; then
  echo "uso: floating-term.sh <comando>"
  exit 1
fi

kitty --class "float-term" -e bash -c "$app; sleep 0.2"
