system_tools=(
    "networkmanager"
    "network-manager-applet"
    "rustup"
    "bluez"
    "bluez-utils"
    "sddm"
    "qt6-svg"
    "qt6-declarative"
    "pacman-contrib"
    "parallel"
    "jq"
    "wl-clipboard"
    "brightnessctl"
    "wget"
    "zip"
    "unzip"
    "ufw"
    "ufw-extras"
    "openssh"
    "mesa"
    "xdg-user-dirs"
    "libva-intel-driver"
    "intel-media-driver"
    "vulkan-intel"
)

multimedia_apps=(
    "pipewire"
    "pipewire-alsa"
    "pipewire-audio"
    "pipewire-jack"
    "pipewire-pulse"
    "gst-plugin-pipewire"
    "wireplumber"
    "ffmpeg"
    "libjpeg-turbo"
    "libpng"
    "libwebp"
    "imagemagick"
    "ffmpeg"
    "noto-fonts"
    "noto-fonts-cjk"
    "noto-fonts-emoji"
    "papirus-icon-theme"
    "bibata-cursor-theme-bin"
    "ttf-jetbrains-mono-nerd"
    "ttf-material-design-icons-extended"
)

utils=(
    "zoxide"
    "cava"
    "btop"
    "lsd"
    "starship"
    "stow"
    "neofetch"
    "tokei"
    "fzf"
    "bat"
    "git-crypt"
)

gnome=(
    "gnome"
    "gnome-tweaks"
    "gnome-boxes"
    "pika-backup"
    "ulauncher"
)

_installPackagesYay "${system_tools[@]}";
_installPackagesYay "${multimedia_apps[@]}";
_installPackagesYay "${utils[@]}";
_installPackagesYay "${gnome[@]}";
