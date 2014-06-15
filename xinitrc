DEFAULT=xmonad
echo $1 >> /home/robert/login_attempts
source ~/.xinitrc.$1 || $1 || $DEFAULT
