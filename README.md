# Gnome dotfiles

Everything with Catppuccin

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

Make sure you replace your git username and email in `.gitconfig`

fazer um `stow .` em gnomedots e instalar os sequintes pacotes:
- gitflow-avh
- gitflow-fishcompletion-avh