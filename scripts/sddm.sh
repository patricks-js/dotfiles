if pkg_installed sddm; then
    echo -e "\033[0;32m[DISPLAYMANAGER]\033[0m detected // sddm"
    if [ ! -d /etc/sddm.conf.d ]; then
        sudo mkdir -p /etc/sddm.conf.d
    fi

    if [ ! -f /etc/sddm.conf.d/theme.t2.bkp ]; then
        echo -e "\033[0;32m[DISPLAYMANAGER]\033[0m configuring sddm..."

        sddmtheme="catppuccin-mocha"

        wget -P ~/Downloads/ https://github.com/catppuccin/sddm/releases/download/v1.0.0/$sddmtheme.zip
        unzip -o ~/Downloads/$sddmtheme.zip -d /usr/share/sddm/themes/

        pacman -Syu qt6-svg qt6-declarative

        sudo touch /etc/sddm.conf.d/theme.conf
        sudo cp /etc/sddm.conf.d/theme.conf /etc/sddm.conf.d/theme.t2.bkp
        sudo cp /usr/share/sddm/themes/${sddmtheme}/theme.conf /etc/sddm.conf.d/
    else
        echo -e "\033[0;33m[SKIP]\033[0m sddm is already configured..."
    fi
else
    echo -e "\033[0;33m[WARNING]\033[0m sddm is not installed..."
fi