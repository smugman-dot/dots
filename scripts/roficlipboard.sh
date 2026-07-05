#!/usr/bin/env bash

selection="$(stash list | rofi \
    -dmenu \
    -i \
    -p "󰅌 Clipboard" \
    -kb-custom-1 "Alt+d")"

ret=$?

case "$ret" in
    0)
        [[ -z "$selection" ]] && exit 0
        printf '%s\n' "$selection" | stash decode | wl-copy
        notify-send "Clipboard" "Copied"
        ;;
    10)
        [[ -z "$selection" ]] && exit 0
        printf '%s\n' "$selection" | stash delete
        notify-send "Clipboard" "Deleted"
        ;;
esac
