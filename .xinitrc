#!/bin/sh
# keyboard repeat rate

# monitor config
xrandr --output DP-0 --mode 1920x1080 --rate 180.003

xset r rate 100 50
xset s off
xset -dpms
xset s noblank

# set wallpaper in background
feh --bg-fill /home/walid/Pictures/wallpapers/wallhaven-zpvqmv.png

# import environment variables to systemd/dbus
if command -v dbus-update-activation-environment >/dev/null 2>&1; then
    dbus-update-activation-environment --systemd DISPLAY XAUTHORITY
fi

# 2. Launch a user D-Bus session if one isn't already running
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax --exit-with-session)
fi

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
dispwin -V /home/walid/Documents/VG249Q3A.icm &

# start dwm inside a D-Bus session
exec dbus-run-session dwm
