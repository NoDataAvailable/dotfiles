#!/bin/bash

OSDFONT="-*-roboto light-light-r-*-*-*-*-*-*-*-*-*-*"
DZFONT="Futura LT:style=Book:size=24"

TOUCHPAD='Elan Touchpad'
KEYBOARD='cros_ec'

TABLET_SWITCH="/tmp/istablet"

if [[ -a $TABLET_SWITCH ]] ; then
    TOGGLE=enable
    FGCLR="#AAFFAA"
    kill `pidof touchegg`
    kill `pidof unclutter`
    rm $TABLET_SWITCH
else
    TOGGLE=disable
    FGCLR="#FF9999"
    touchegg &
    unclutter -root -idle 0.01 &
    touch $TABLET_SWITCH
fi

xinput $TOGGLE "$TOUCHPAD"
xinput $TOGGLE "$KEYBOARD"

( echo "Input $TOGGLE""d!"; sleep 2 ) |
    dzen2 -w 384 -x 448 -y 320 -h 64 -ta c \
        -fn "$DZFONT" -bg '#222222' -fg "$FGCLR"
