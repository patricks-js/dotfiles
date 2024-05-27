#!/usr/bin/env bash

source fn.sh

if [ $? -ne 0 ]; then
    echo "Error: unable to source fn.sh..."
    exit 1
fi

cat <<"EOF"

 __     __   __     ______     ______   ______     __         __         __     __   __     ______
/\ \   /\ "-.\ \   /\  ___\   /\__  _\ /\  __ \   /\ \       /\ \       /\ \   /\ "-.\ \   /\  ___\
\ \ \  \ \ \-.  \  \ \___  \  \/_/\ \/ \ \  __ \  \ \ \____  \ \ \____  \ \ \  \ \ \-.  \  \ \ \__ \
 \ \_\  \ \_\\"\_\  \/\_____\    \ \_\  \ \_\ \_\  \ \_____\  \ \_____\  \ \_\  \ \_\\"\_\  \ \_____\
  \/_/   \/_/ \/_/   \/_____/     \/_/   \/_/\/_/   \/_____/   \/_____/   \/_/   \/_/ \/_/   \/_____/

EOF

./preparation.sh
sleep 2
./yay.sh
sleep 2
./install.sh package.lst
sleep 2
./etc.sh
sleep 2
./cleanup.sh
sleep 1
