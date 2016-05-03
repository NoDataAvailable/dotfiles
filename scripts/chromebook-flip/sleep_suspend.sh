echo "Five seconds to shut the lid!" | osd_cat -d 4 -s 5 -p middle -A center

sleep 2
source ~/bin/fancy_lock
sleep 3

xinput -disable 'Elan Touchscreen'
systemctl suspend
xinput -enable 'Elan Touchscreen'
