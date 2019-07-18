if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?* ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

setxkbmap de

xmodmap ~/.Xmodmap
export _JAVA_AWT_WM_NONREPARENTING=1
export QT_QPA_PLATFORMTHEME="qt5ct"
#export XDG_CURRENT_DESKTOP="KDE" # breaks xdg-open
#pulseaudio --start
urxvtd -q -f -o
dunst &
#unclutter -idle 30 -jitter 2 -root &
numlockx &
#xrandr --setprovideroutputsource Intel NVIDIA-0
#/home/choopm/.scripts/toggletouchpad.sh

if [ $(blkid -U F7C0-A91D | wc -l) -eq 1 ]; then
  /home/choopm/.scripts/triplemon.sh /home/choopm/Dokumente/Wallpaper/dalek.png
fi
if [ $(blkid -U E6DE-18C2 | wc -l) -eq 1 ]; then
  /home/choopm/.scripts/triplemon-work.sh /home/choopm/Dokumente/Wallpaper/dalek.png
fi

echo 140 | sudo tee /sys/devices/platform/i8042/serio1/serio2/sensitivity

exec i3
