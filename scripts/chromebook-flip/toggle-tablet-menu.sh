DZFONT="Futura LT:style=Book:size=24"

MENU_PID="/tmp/touch-menu.pid"

if [[ -a $MENU_PID ]] ; then
    kill `cat $MENU_PID`
    rm $MENU_PID
else
    dzen2 -w 64 -x 1216 -y 0 -h 64 -ta c -sa c -l 5 \
        -fn "$DZFONT" -bg '#222222' -p -m < ~/scripts/1chmenu &
    echo $! > $MENU_PID
fi
