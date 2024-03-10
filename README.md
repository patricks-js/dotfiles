Setup:

Everything with Catppuccin

- [ ] cliphist

ANSI Shadow: https://patorjk.com/software/taag/

## Install fisher

```bash
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
fisher install jorgebucaran/fisher
fisher install catppuccin/fish
fish_config theme save "Catppuccin Mocha"
```

## TPM - Tmux

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## GTK Setup

```bash
yay -S catppuccin-gtk-theme-mocha
# 
THEME_DIR=/usr/share/themes/Catppuccin-Mocha-Standard-Blue-Dark
mkdir -p "$HOME/.config/gtk-4.0"
ln -sf "$THEME_DIR/gtk-4.0/assets" "$HOME/.config/gtk-4.0/assets"
ln -sf "$THEME_DIR/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"
ln -sf "$THEME_DIR/gtk-4.0/gtk-dark.css" "$HOME/.config/gtk-4.0/gtk-dark.css"
```