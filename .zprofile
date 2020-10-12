#/usr/bin/env zsh

[[ "$TTY" == /dev/tty* ]] || return 0

export $(systemctl --user show-environment)

if [[ -z $DISPLAY && "$TTY" == "/dev/tty1" ]]; then
    systemd-cat -t sway sway
    systemctl --user stop sway-session.target
    systemctl --user unset-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK
fi

