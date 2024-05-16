#!/usr/bin/env bash

source fn.sh

cp lists/_base.lst package.lst

./install.sh package.lst
rm package.lst

./font.sh lists/_fonts.lst
./theme.sh lists/_themes.lst
./zsh.sh lists/_zsh_plugins.lst
./config.sh lists/_configs.lst
./etc.sh

while read srv; do
  if [[ $(systemctl list-units --all -t service --full --no-legend "${srv}.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "${srv}.service" ]]; then
    echo "$srv service is already enabled, enjoy..."
  else
    echo "$srv service is not enabled, enabling..."
    sudo systemctl enable ${srv}.service
    if [[ "$srv" != "nvidia-suspend" && "$srv" != "nvidia-hibernate" && "$srv" != "nvidia-resume" ]]; then
      sudo systemctl start ${srv}.service
      echo "$srv service enabled and started..."
    fi
  fi
done < <(cut -d '#' -f 1 lists/_system.lst)
