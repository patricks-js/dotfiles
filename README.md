# Dotfiles

This is my personal collection of configuration files.

Here are some details about my setup:

- **Distro**: [Arch Linux](https://archlinux.org/)
- **Window Manager**: [Hyprland](https://hyprland.org/)
- **Status Bar**: [Waybar](https://github.com/Alexays/Waybar)
- **Widgets:** [eww](https://github.com/elkowar/eww)
- **Terminal**: [kitty](https://sw.kovidgoyal.net/kitty/)
- **Notifications**: [dunst](https://github.com/dunst-project/dunst)
- **Video Player**: [mpv](https://github.com/mpv-player/mpv)
- **Shell:** [fish](https://fishshell.com/)
- **File Manager:** [thunar](https://github.com/xfce-mirror/thunar)
- **Application Launcher:** [rofi](https://github.com/davatorium/rofi)

## Where is everything?

Most config files for various programs can be found in the `.config` directory. Shell scripts can be found in the `.local/bin` directory.

## Dotfiles manager

I'm using `GNU stow` to manage my dotfiles, it automatically creates symbolic links in the home directory by simply running `stow .` in the dotfiles folder.
