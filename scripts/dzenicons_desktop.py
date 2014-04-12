#!/usr/bin/python2

import os
from time import sleep
from urllib2 import urlopen

# DBus communication stuff
from dbus import DBusException
from dbus import version as dbus_version
import gobject
from wicd import dbusmanager

icon_dir = "/home/robert/dzen-icons/xbm8x8/"

icon = lambda name : icon_dir + name + ".xbm"

def value(path):
    fp = open(path)
    val = fp.readline().rstrip()
    fp.close()
    return val

iValue = lambda path : int(value(path))
fValue = lambda path : float(value(path))

def gdbar(label, fill, colour, width):
    bar = os.popen("echo " + str(fill) + " | gdbar -s o -h 6 -fg " + colour + " -w " + str(width) + " -l '" + label + "'")
    gdbar = bar.read().rstrip()
    bar.close()
    return gdbar

def new_icon(colour, icon_name, percent, bar):
    newIcon =  "  ^fg(%s)^i(%s)^fg() " % (colour, icon(icon_name))
    if bar:
        return gdbar(newIcon, percent, colour, bar)
    else:
        return newIcon

# Borrowed (see: mostly copied) from wicd's source
def setup_dbus(force=True):
    global bus, daemon, wireless, wired
    try:
        dbusmanager.connect_to_dbus()
    except DBusException:
        wicd = False
    bus = dbusmanager.get_bus()
    dbus_ifaces = dbusmanager.get_dbus_ifaces()
    daemon = dbus_ifaces['daemon']
    wireless = dbus_ifaces['wireless']
    wired = dbus_ifaces['wired']

    if not daemon:
        return False

    return True

# Colours!!!
red     = "'#FF4848'" # "red"
orange  = "'#FFC65B'" # "orange"
yellow  = "'#FFFF84'" # "yellow"
green   = "'#78FC4E'" # "green"
blue    = "'#75B4FF'" # "blue"
cyan    = "'#75ECFD'" # "cyan"
skyblue = "'#B5FFFC'" # "skyblue"
grey    = "'#999999'" # "grey"

# Volume/Music (Soon)
vol_icons   = ["spkr_02","spkr_01","spkr_01","spkr_01","spkr_01"]
vol_colours = [grey,blue,yellow,orange,red]

vol_status = 0

# Weather
weath_icon = "temp"
weath_colours = [cyan,skyblue,green,yellow,orange,red]

location = "CYYZ"
weather_url = "http://weather.noaa.gov/pub/data/observations/metar/decoded/" + location + '.TXT'
online = False

# CPU Load
cpu_icon = "cpu"
cpu_colours = [green, yellow, orange, red]

cpu_stat = "/proc/stat"
cpu_temp = "/sys/class/hwmon/hwmon2/device/temp1_input"
prev_total = 0
prev_idle = 0

# GPU Stuff
gpu_icon = "scorpio"
gpu_colours = cpu_colours

gpu_temp = "/sys/class/hwmon/hwmon2/device/temp1_input"

# RAM Usage
ram_icon = 'mem'
ram_colours = cpu_colours

ram_usage = '/proc/meminfo'

# Network Connection
net_icons = ["net_wired","wifi_02","wifi_02","wifi_02","wifi_02"]
net_colours = [cyan,red,orange,green,cyan]

dbus_up = setup_dbus()
ip = ""


# Main Loop

count = 0

while True:
    output = ""
    slave = "| "

    if count >= 900:
        count = 0

    # GPU
#    gpu_temperature = iValue(gpu_temp)/1000
 #   if gpu_temperature <= 40:
  #      gpu_state = 0
   # else:
#        gpu_state = (gpu_temperature - 40) / 15
 #   output += '  |' + new_icon(gpu_colours[gpu_state], gpu_icon, gpu_temperature, 25)
  #  slave +=  ' [' + str(gpu_temperature) + " C]"

    # CPU
    stats = value(cpu_stat).split()
    stats.pop(0)
    total = sum([int(i) for i in stats])
    idle = int(stats[3])
    cpu_percent = (1000 * (total-prev_total-idle+prev_idle)/(total-prev_total) + 5) / 10
    prev_total = total
    prev_idle = idle
    if cpu_percent >= 97:
        cpu_percent = 97
    cpu_state = cpu_percent / 25
    output += ' ' + new_icon(cpu_colours[cpu_state], cpu_icon, cpu_percent, 25)
    slave += ' [' + str(iValue(cpu_temp) / 1000) + " C]"

    # RAM Usage
    fp = open(ram_usage)
    ram_list = [int(i.split()[1]) for i in fp.read().rstrip().split('\n')]
    fp.close()
    ram_use = (1000 * (ram_list[0] - sum([ram_list[i] for i in range(1,4)]))/(ram_list[0]) + 5) / 10
    if ram_use <= 25:
        ram_state = 0
    else:
        ram_state = (ram_use - 21) / 20
    output += ' ' + new_icon(ram_colours[ram_state], ram_icon, ram_use, 25)
    slave += ' [' + "%3d" % (ram_use) + '%]'

    # Wireless
    if dbus_up:
        net_id = wireless.GetCurrentNetworkID(0)
        if net_id >= 0:
            ssid = wireless.GetWirelessProperty(net_id, "essid")
            strength = int(wireless.GetWirelessProperty(net_id, "quality"))
            ip = wireless.GetWirelessIP('')
            if strength >= 97:
                strength = 97
        else:
            ssid = "n/a"
            strength = -1
    else:
        ssid = 'n/a'
        strength = -1
    net_state = (strength + 50) / 50 + 1
    if net_state <= 1 and not ip:
        net_state = 4
    #output +=  ' ' + new_icon(net_colours[net_state], net_icons[net_state], strength, 25)
    output +=  '  |' + new_icon(net_colours[net_state], net_icons[net_state], strength, 0) + ' ' + ip
    slave += ' [' + "%3d" % (strength) + '%]'

    # Weather
    if net_state != 1 and net_state != 4:
        if count == 0:
            try:
                weath_file = urlopen(weather_url)
                weath_lines = weath_file.read().split('\n')
                city = weath_lines[0].split()[0]
                temp_str = weath_lines[5].split('(')[1].rstrip(')')
                temp = int(temp_str.split()[0])
                temp_str = "%2d C" % temp
                if temp <= 0:
                    temp_status = 0
                elif temp > 40:
                    temp_status = 5
                else:
                    temp_status = temp / 10 + 1
                online = True
            except:
                online = False
        if online:
            output += '  |' + new_icon(weath_colours[temp_status], weath_icon, temp, 0) + ' ' + temp_str
            slave += '  |  ' + city

    # Audio
    raw_line = os.popen("amixer sget Master | grep %")
    line =  raw_line.read()
    raw_line.close()
    volume =  int(line[line.find("%")-3:line.find("%")].lstrip(' ['))
    if not volume:
        vol_status = 0
    else:
        vol_status = (volume-1)/25 + 1
    if volume < 4:
        volume += 3
    output += '  |' + new_icon(vol_colours[vol_status], vol_icons[vol_status], volume-3, 60)# \
    slave  += '  |  ' +  ' [' + "%3d" % (volume) + '%] ' \
        + "^fg(" + red + ")^ca(1,'ncmpcpp volume  -5')^i(" + icon('net_down_03') + ")^ca()^fg()" \
        + " ^fg(" + green + ")^ca(1,'ncmpcpp volume  +5')^i(" + icon('net_up_03') + ")^ca()^fg()"
    #slave += '  |


    os.system("echo '" + output + "  |'")
    #os.system("echo '" + slave + "  |'")

    sleep(1)

