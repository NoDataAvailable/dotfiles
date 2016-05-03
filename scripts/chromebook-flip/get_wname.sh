#!/bin/bash

ID=$(xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)" | sed "s/.*# //g")
NAME=$(xprop -id $ID | grep "WM_NAME(UTF8_STRING)" | sed "s/.*\"\(.*\)\"/\1/g")

echo $NAME
echo $NAME
