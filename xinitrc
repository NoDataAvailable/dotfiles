DEFAULT=xmonad
echo $1 >> ~/login_attempts
source ~/.xinitrc.$1 || $1 || $DEFAULT
