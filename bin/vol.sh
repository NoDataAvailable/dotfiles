#!/bin/bash

DZFONT="Futura LT:style=Book:size=24"
FAFONT="Font Awesome:size=24"

OLDVOL=$(ponymix get-volume)
if [[ -n $1 ]] ; then 
    NEWVOL=$(ponymix set-volume $(echo $OLDVOL $1 5 | bc))
else 
    NEWVOL=$OLDVOL
fi

GDBAR=$(echo $NEWVOL | gdbar -h 32 -w 256)
(echo "^fn($FAFONT) ^fn()$GDBAR $NEWVOL" && sleep 2) |
    dzen2 -w 384 -x 448 -y 320 -h 64 -ta c \
        -fn "$DZFONT" -bg '#222222'
