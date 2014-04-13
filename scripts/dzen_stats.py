#!/usr/bin/python

from time import sleep
import subprocess
import urllib.request
import json
import alsaaudio
import datetime

# Definitions:
MEM_FILE = "/proc/meminfo"
CPU_STAT = "/proc/stat"
TCP_FILE = "/proc/net/tcp"
WEATHER_ID = "6075357"

ICON_DIR = "/home/robert/dzen-icons/xbm8x8/"
WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?id=" +\
                WEATHER_ID + "&units=metric"

BAR_HEIGHT = 2
BAR_WIDTH  = 20

# Colours!
RED     = "#FF4848" # "red"
ORANGE  = "#FFC65B" # "orange"
YELLOW  = "#FFFF84" # "yellow"
GREEN   = "#78FC4E" # "green"
BLUE    = "#75B4FF" # "blue"
CYAN    = "#A5D3CA" # "cyan"
SKYBLUE = "#67C7E2" # "skyblue"
GREY    = "#999999" # "grey"

COLOUR_LEVELS = [GREEN, GREEN, YELLOW, ORANGE, RED]

# Initialization of values
cpu_fp = open(CPU_STAT)
times  = cpu_fp.readline().split()
times.pop(0)
cpu_idle_p  = int(times[3])
cpu_total_p = sum([int(t) for t in times])
connected = False
ip = "0.0.0.0"
temperature_s = "???"
temperature_i = 0
counter = 0

icon_path = lambda name : ICON_DIR + name + ".xbm"

def icon(name, percent):
    colour = COLOUR_LEVELS[int(min(99,percent)/20)]
    return "^fg({0})^i({1})^fg()".format(colour, icon_path(name))

def mock_gdbar(percent, width=BAR_WIDTH, height=BAR_HEIGHT):
    colour = COLOUR_LEVELS[int(min(99,percent)/20)]
    return "^ib(1)^fg({0})^ro({1}x{2})^p({3})^fg({4})^r({5}x{6})^p({7})^ib(0)^fg()".format(
        GREY,       # outline colour
        width + 4,  # outline width
        height + 4, # outline height
        -2 - width, # move cursor back to draw actual bar
        colour,     # bar colour
        int(width * percent/100),
        height,
        width + 2 - int(width * percent/100) # reposition cursor
        )

dzen_monitor = subprocess.Popen(["dzen2", "-w", "840", "-x", "1470", "-h", "15",
            "-ta", "r", "-bg", "#222222", "-dock" ], stdin=subprocess.PIPE)

dzen_date = subprocess.Popen(["dzen2", "-w", "250", "-x", "2310", "-h", "15",
            "-ta", "c", "-bg", "#222222", "-dock" ], stdin=subprocess.PIPE)

while not sleep(1):
    mem_fp = open(MEM_FILE)
    mem_total = int(mem_fp.readline().split()[1])
    mem_free  = int(mem_fp.readline().split()[1])
    mem_used  = 100 - int(100*mem_free/mem_total)
    mem_fp.close()

    cpu_fp = open(CPU_STAT)
    times  = cpu_fp.readline().split()
    times.pop(0)
    cpu_idle  = int(times[3])
    cpu_total = sum([int(t) for t in times])
    cpu_used  = 100 - int(100 * (cpu_idle-cpu_idle_p)/(cpu_total-cpu_total_p))
    cpu_idle_p  = cpu_idle
    cpu_total_p = cpu_total
    cpu_fp.close()

    ip_fp = open(TCP_FILE)
    for i in range(2):
        ip_fp.readline()
    sample_tcp = ip_fp.readline()
    if sample_tcp:
        connected = True
        sample_tcp = sample_tcp.split()[1]
        ip = [int(h, 16) for h in [sample_tcp[6-i:8-i] for i in range(0,8,2)]]
        ip = ".".join([str(i) for i in ip])
    else:
        connected = False

    if counter == 0:
        try:
            weather_json = urllib.request.urlopen(WEATHER_URL)
            weather_json = weather_json.read().decode('utf-8')
            weather_data = json.loads(weather_json)
            temp = weather_data['main']['temp']
            temperature_s = str(temp) + " C"
            temperature_i = min(max(temp, 0) * 2, 99)
        except:
            print("Failed Weather Fetch")

    try:
        volume = max(min(alsaaudio.Mixer(cardindex=2).getvolume()[0], 99), 1)
    except:
        volume = 50

    counter = (counter + 1) % 300   # Reset every 5 minutes

    monitor_output = "{0} {1}   {2} {3}  |  {4}  {5}  |  {6}  {7}  |  {8}  {9}  |\n".format(
            icon("cpu", cpu_used),
            mock_gdbar(cpu_used),
            icon("mem", mem_used),
            mock_gdbar(mem_used),
            icon("wifi_02", 0 if connected else 99),
            ip,
            icon("temp", temperature_i),
            temperature_s,
            icon("spkr_01", volume),
            mock_gdbar(volume, width=3*BAR_WIDTH),
            )

    date_output = datetime.datetime.now().strftime( 
                    "^fg(" + CYAN + ")%A %B %d^fg() ^fg(" + SKYBLUE +\
                    ")%I:%M%P^fg()  ^i(" + icon_path("clock") + ")\n"
                    )

    #print(dzen_output)
    dzen_monitor.stdin.write(bytes(monitor_output, "ascii"))
    dzen_monitor.stdin.flush()

    dzen_date.stdin.write(bytes(date_output, "ascii"))
    dzen_date.stdin.flush()
