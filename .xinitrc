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
urxvtd -q -f -o
dunst &

if [ $(blkid -U F7C0-A91D | wc -l) -eq 1 ]; then
  /home/choopm/.scripts/triplemon.sh /home/choopm/Dokumente/Wallpaper/dalek.png
fi
if [ $(blkid -U E6DE-18C2 | wc -l) -eq 1 ]; then
  /home/choopm/.scripts/triplemon-work.sh /home/choopm/Dokumente/Wallpaper/dalek.png
fi

exec i3
