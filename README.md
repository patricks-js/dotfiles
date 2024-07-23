# Dotfiles

This is my personal collection of configuration files and scripts for Hyprland in Arch Linux.

Here are some details about my setup:

- **Distro**: [Arch Linux](https://archlinux.org/)
- **Window Manager**: [Hyprland](https://hyprland.org/)
- **Status Bar**: [Waybar](https://github.com/Alexays/Waybar)
- **Terminal**: [kitty](https://sw.kovidgoyal.net/kitty/)
- **Notifications**: [dust](https://dunst-project.org/)
- **Shell:** [fish](https://fishshell.com/)
- **File Manager:** [nautilus](https://apps.gnome.org/Nautilus/)
- **Application Launcher:** [rofi](https://davatorium.github.io/rofi/)
- **Neovim Distro**: [lazyVim](https://www.lazyvim.org/)

## Where is everything?

Most config files for various programs can be found in the `.config` directory. Shell scripts can be found in the `.local/share/bin` directory.

## Dotfiles manager

I'm using `GNU stow` to manage my dotfiles, it automatically creates symbolic links in the home directory by simply running `stow .` in the dotfiles folder.

## Inspirations

The following projects have inspired me:

- <https://github.com/mylinuxforwork/dotfiles>
- <https://github.com/prasanthrangan/hyprdots>
- <https://github.com/gh0stzk/dotfiles>

and many more...
