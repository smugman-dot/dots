#!/bin/bash

options="󰐥 Shutdown\n󰜉 Reboot\n󰍃 Logout\n󰌾 Lock\n󰗽 Suspend"

choice=$(echo -e "$options" | fuzzel --dmenu -p "power") 
case "$choice" in
  *Shutdown*) systemctl poweroff ;;
  *Reboot*) systemctl reboot ;;
  *Logout*) hyprctl dispatch exit ;;
  *Lock*) loginctl lock-session ;;
  *Suspend*) systemctl suspend ;;
esac

