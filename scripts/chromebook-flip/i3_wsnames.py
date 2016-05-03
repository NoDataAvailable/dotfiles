#!/usr/bin/env python3

import i3ipc

i3 = i3ipc.Connection()

default_icon = '\uf013'
icon_dict = {
        "Lxterminal" : '\uf120',
        "Firefox"    : '\uf269',
        "mpv"        : '\uf144',
        }

def on_window_focus(i3, e):
    focused = i3.get_tree().find_focused()
    leaves = focused.workspace().leaves()
    iconify = lambda name : icon_dict[name] if name in icon_dict else default_icon
    names = [iconify(lv.window_class) for lv in leaves]
    ws_name = "%s: %s" % (focused.workspace().num, "  ".join(names))
    i3.command('rename workspace to "%s"' % ws_name)

# Subscribe to events
i3.on("window::focus", on_window_focus)

# Start the main loop and wait for events to come in.
i3.main()
