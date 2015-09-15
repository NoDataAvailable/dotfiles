
xset +fp /usr/share/fonts/artwiz-fonts
xset fp rehash

xrdb ~/.Xresources
~/.screenlayout/DualMon.sh
nitrogen --restore
#compton -bc
[[ -z $(pidof mpd) ]] && mpd
[[ -z $(pidof xflux) ]] && xflux -r 1 -l 43.1500 -g -79.5000
exec i3
