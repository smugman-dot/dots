#!/bin/bash

options="󰐥 Shutdown\n󰜉 Reboot\n󰍃 Logout\n󰌾 Lock\n󰗽 Suspend"

choice=$(echo -e "$options" | rofi -dmenu \
  -p "power" \
  -theme-str '
* {
    font: "JetBrainsMono Nerd Font 13";
    bg: #1e1e2e;
    bg-alt: #181825;
    fg: #cdd6f4;
    fg-alt: #7f849c;
    accent: #f38ba8;
}
window {
    width: 22%;
    location: center;
    anchor: center;
    background-color: @bg;
    border-radius: 20px;
}
mainbox {
    padding: 20px;
}
listview {
    lines: 5;
    spacing: 10px;
}
element {
    padding: 14px;
    border-radius: 14px;
}
element selected {
    background-color: @accent;
    text-color: @bg;
}
'
)

case "$choice" in
  *Shutdown*) systemctl poweroff ;;
  *Reboot*) systemctl reboot ;;
  *Logout*) hyprctl dispatch exit ;;
  *Lock*) loginctl lock-session ;;
  *Suspend*) systemctl suspend ;;
esac

