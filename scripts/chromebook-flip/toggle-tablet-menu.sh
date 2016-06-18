#!/bin/bash

DZFONT="Font Awesome:size=24"
#DZFONT="Futura LT:style=Book:size=24"

MENU_PID="/tmp/touch-menu.pid"
MENUFILE="/home/rgb/scripts/1chmenu"

SZ=58
XOFF=$(echo "1280 - $SZ" | bc)
NLINE=$(cat $MENUFILE | wc -l)

if [[ -a $MENU_PID ]] ; then
    kill `cat $MENU_PID`
    rm $MENU_PID
else
    dzen2 -w $SZ -x $XOFF -y 0 -h $SZ -ta c -sa c -l $NLINE \
        -fn "$DZFONT" -bg '#222222' -p -m < $MENUFILE &
    echo $! > $MENU_PID
fi
