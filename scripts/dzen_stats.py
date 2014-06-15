#!/usr/bin/python

from time import sleep
import subprocess
import urllib.request
import json
import alsaaudio
import mpd
import datetime

# Config
WEATHER_ID = "6075357"
SND_CARD_NAME = "PCH"
MPD_COMM = "urxvt -e ncmpcpp"


# Definitions:
MEM_FILE = "/proc/meminfo"
CPU_STAT = "/proc/stat"
TCP_FILE = "/proc/net/arp"
AUDIO_CARD = None

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
mpd_loaded = False
mpd_client = mpd.MPDClient()    # init MPD Client
mpd_output = "^fg(" + RED + ")Loading...^fg()\n"


icon_path = lambda name : ICON_DIR + name + ".xbm"

t_fmt = lambda sec : "%d:%.2d" % (sec/60,sec%60)

def icon(name, percent):
    colour = COLOUR_LEVELS[int(min(99,percent)/20)]
    return "^fg({0})^i({1})^fg()".format(colour, icon_path(name))

def mock_gdbar(*percent, width=BAR_WIDTH, height=BAR_HEIGHT):
    percent = sorted(percent, reverse=True)

    bar = "^ib(1)^fg({0})^ro({1}x{2})^p({3})".format(
        GREY,       # outline colour
        width + 4,  # outline width
        height + 4, # outline height
        -2 - width, # move cursor back to draw actual bar
        )

    for i, p in enumerate(percent):
        colour = COLOUR_LEVELS[int(min(99,p)/20)]
        if i == len(percent) - 1:
            move = width + 2 - int(width * p/100)
        else:
            move = - int(width * p/100)
        bar += "^fg({0})^r({1}x{2})^p({3})".format(
            colour,     # bar colour
            int(width * p/100),
            height,
            move # reposition cursor
        )

    bar += "^ib(0)^fg()"
    return bar


for card in enumerate(alsaaudio.cards()):
    AUDIO_CARD = card[0] if card[1] == SND_CARD_NAME else AUDIO_CARD

try:
    mpd_client.connect("localhost", 6600)	# connect to local MPD Server
    mpd_loaded = True
except:
    mpd_loaded = False

dzen_monitor = subprocess.Popen(["dzen2", "-w", "840", "-x", "1470", "-h", "15",
            "-ta", "r", "-bg", "#222222", "-dock" ], stdin=subprocess.PIPE)

dzen_date = subprocess.Popen(["dzen2", "-w", "250", "-x", "2310", "-h", "15",
            "-ta", "c", "-bg", "#222222", "-dock" ], stdin=subprocess.PIPE)

dzen_mpd = subprocess.Popen(["dzen2", "-w", "950", "-x", "2560", "-h", "15",
            "-ta", "l", "-bg", "#222222", "-dock" ], stdin=subprocess.PIPE)

while not sleep(1):
    mem_fp = open(MEM_FILE)
    mem_total = int(mem_fp.readline().split()[1])
    mem_free  = int(mem_fp.readline().split()[1])
    mem_avail = int(mem_fp.readline().split()[1])
    mem_used  = 100 - int(100*mem_free/mem_total)
    mem_reserved = 100 - int(100*mem_avail/mem_total)
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
    ip_fp.readline()
    sample_tcp = ip_fp.readline()
    if sample_tcp:
        connected = True
        ip = sample_tcp.split()[0]
    else:
        connected = False
    ip_fp.close()

    if counter == 0:
        try:
            weather_json = urllib.request.urlopen(WEATHER_URL)
            weather_json = weather_json.read().decode('utf-8')
            weather_data = json.loads(weather_json)
            temp = weather_data['main']['temp']
            temperature_i = min(max(temp, 0) * 2, 99)
            temperature_s = str(temp) + "°C"
            temp = weather_data['weather'][0]['description']
            temperature_s = temperature_s + " ( " + temp + " )"
        except:
            print("Failed Weather Fetch")

    try:
        volume = alsaaudio.Mixer(cardindex=AUDIO_CARD).getvolume()[0]
        volume = max(min(volume, 99), 1)
    except:
        volume = 50

    counter = (counter + 1) % 300   # Reset every 5 minutes

    monitor_output = "{0} {1}   {2} {3}  |  {4}  {5}  |  {6}  {7}  |  {8}  {9}  |\n".format(
            icon("cpu", cpu_used),
            mock_gdbar(cpu_used),
            icon("mem", mem_reserved),
            mock_gdbar(mem_used, mem_reserved),
            icon("wifi_02", 0 if connected else 99),
            ip,
            icon("temp", temperature_i),
            temperature_s,
            icon("phones", volume),
            mock_gdbar(volume, width=3*BAR_WIDTH),
            )

    date_output = datetime.datetime.now().strftime(
                    "^fg(" + CYAN + ")%A %B %d^fg() ^fg(" + SKYBLUE +\
                    ")%I:%M%P^fg()  ^i(" + icon_path("clock") + ")\n"
                    )

    if mpd_loaded:
        current_song = mpd_client.currentsong()     # get the currentsong dict
        mpd_status = mpd_client.status()
        music_icon = "^ca(1, " + MPD_COMM + ') ' + icon('note', 1) + " ^ca()"
        state_icon = "^ca(1, mpc toggle) " + icon(mpd_status['state'], 50) + " ^ca()"
        mpd_vol = " {0} {1}% ".format(
                icon('spkr_01', int(mpd_status['volume'])),
                mpd_status['volume']
                )
        if mpd_status['state'] != 'stop':
            song_file = current_song['file'].split('/')
            if 'album' in current_song.keys():
                album = current_song['album']
            else:
                album = song_file[-2]
            if 'title' in current_song.keys():
                title = current_song['title']
            else:
                title = song_file[-1]
            if 'artist' in current_song.keys():
                artist = current_song['artist']
            elif 'albumartist' in current_song.keys():
                artist = current_song['albumartist']
            else:
                atrist = "Unknown Artist"
            song_time = [int(s) for s in mpd_status['time'].split(':')]
            song_time = " [{0}] [{1}] [{2}] [ {3} / {4} ]  ".format(
                    music_icon,
                    mpd_vol,
                    state_icon,
                    t_fmt(song_time[0]),
                    t_fmt(song_time[1])
                    )
        else:
            album = ""
            title = "Not Playing"
            artist = ""
            song_time = "  [ " + music_icon + " ] [ 0:00 / 0:00 ]  "
        mpd_output = "{6}^fg({0}){1}^fg() -- ^fg({2}){3}^fg() -- ^fg({4}){5}^fg()\n".format(
                SKYBLUE,
                artist,
                ORANGE,
                title,
                GREEN,
                album,
                song_time
                )
    else:
        try:
            mpd_client.connect("localhost", 6600)	# connect to local MPD Server
            mpd_loaded = True
        except:
            mpd_loaded = False
            mpd_output = "^fg(" + RED + ")Loading...^fg()\n"

    dzen_monitor.stdin.write(bytes(monitor_output, "utf-8"))
    dzen_monitor.stdin.flush()

    dzen_date.stdin.write(bytes(date_output, "utf-8"))
    dzen_date.stdin.flush()

    dzen_mpd.stdin.write(bytes(mpd_output, "utf-8"))
    dzen_mpd.stdin.flush()
