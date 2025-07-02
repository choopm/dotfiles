# dotfiles

This repository stores my home configurations.

The [Taskfile](Taskfile.yml) defines several [Tasks](https://taskfile.dev/) to
take care of integrating these configs with the system.

## Install dotfiles

```shell
git clone --recursive https://github.com/choopm/dotfiles.git ~/git/dotfiles
cd ~/git/dotfiles
task install
```

## Required or useful things

```shell
sudo pacman -Syu \
    jq \
    go-task \
    grim slurp \
    kitty \
    mako \
    neovim \
    starship \
    sway swaybar swaybg py3status \
    wl-clipboard \
    wofi \
    xdg-desktop-portal-wlr
```
