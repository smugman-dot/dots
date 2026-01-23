#!/bin/sh

# keyboard repeat rate
xset r rate 100 50

# monitor config
xrandr --output DP-0 --mode 1920x1080 --rate 180.003

feh --bg-fill /home/walid/Downloads/wallhaven-mlzgmy.jpg

# start dwm inside a D-Bus session
exec dbus-run-session dwm

