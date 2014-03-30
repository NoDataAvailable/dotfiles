#!/usr/bin/python2

import mpd 
from time import sleep	 # Import Internal Time Module
import os
#import shutil

icon_dir = "/home/robert/dzen-icons/xbm8x8/"

icon = lambda name : icon_dir + name + ".xbm"

def value(path):
    fp = open(path)
    val = fp.readline().rstrip()
    fp.close()
    return val 

iValue = lambda path : int(value(path))
fValue = lambda path : float(value(path))

def gdbar(label, fill, colour, width, full):
    bar = os.popen("echo " + str(fill) + " | gdbar -s o -h 6 -fg " + colour + " -w " + str(width) + " -max "  + str(full) + " -l '" + label + "'")
    gdbar = bar.read().rstrip()
    bar.close()
    return gdbar

def new_icon(colour, icon_name, percent, bar, full):
    newIcon =  "  ^fg(%s)^i(%s)^fg() " % (colour, icon(icon_name))
    if bar:
        return gdbar(newIcon, percent, colour, bar, full)
    else:
        return newIcon 

t_fmt = lambda sec : "%d:%.2d" % (sec/60,sec%60)

# Colours!!!
red     = "'#FF4848'" # "red"
orange  = "'#FFC65B'" # "orange"
yellow  = "'#FFFF84'" # "yellow"
green   = "'#78FC4E'" # "green"
blue    = "'#75B4FF'" # "blue"
cyan    = "'#75ECFD'" # "cyan"
skyblue = "'#B5FFFC'" # "skyblue"
grey    = "'#999999'" # "grey"

os.system("echo '^fg(" + red + ")Loading...^fg()'")
sleep(3) # To be sure mpd has started

client = mpd.MPDClient()		# init MPD Client
client.connect("localhost", 6600)	# connect to local MPD Server

fields = [('album',blue),('title',orange),('artist',green)]


while True:
    cs = client.currentsong()       # get the currentsong dict
    status = client.status()
    output = ""
    if cs and status['state'] != 'stop':
		for field in fields:
			if field[0] in cs.keys():
				output += "^fg(" + field[1] + ")" + cs[field[0]] + "^fg() -- "
    else:
        output = "^fg(" + grey + ") -- ^fg()" + "^fg(" + red + ") Nothing Playing ^fg()" + "^fg(" + grey + ") -- ^fg()"

    output = output.rstrip(' -- ')
    
    while len(output) < 150:
        output += ' '
    
    if status['state'] != 'stop':
	time = [int(i) for i in status['time'].split(':')]
    else:
        time = [0,1]
    output += "^ca(1, 'ncmpcpp toggle')" + new_icon(yellow, status['state'], time[0], 150, time[1]) + "^ca()"
    output += "  %s / %s " % (t_fmt(time[0]),t_fmt(time[1]))

    os.system("echo '" + output + "'")

    sleep(1)
