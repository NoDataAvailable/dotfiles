DZFONT="Font Awesome:size=24"

dzen2 -w 1024 -x 64 -y 368 -h 64 -ta c -sa c -l 8 \
    -fn "$DZFONT" -bg '#222222' -p -m h \
    -e "button1=menuprint,exit" < ${0%/*}/wsnames

