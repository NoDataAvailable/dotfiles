#!/usr/bin/env bash

DZFONT="Futura LT:style=Book:size=24"

(echo "Shut the lid!" && sleep 3) |
    dzen2 -w 300 -x 490 -y 320 -h 64 -ta c -fn "$DZFONT" -bg '#222222'

~/bin/fancy_lock
sleep 2

xinput -disable 'Elan Touchscreen'
systemctl suspend
xinput -enable 'Elan Touchscreen'
