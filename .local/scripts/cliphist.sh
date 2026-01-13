#!/usr/bin/env bash
#  ┏┓┓ ┳┏┓┓┏┳┏┓┏┳┓
#  ┃ ┃ ┃┃┃┣┫┃┗┓ ┃
#  ┗┛┗┛┻┣┛┛┗┻┗┛ ┻
#

## /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Clipboard Manager. This script uses cliphist, rofi, and wl-copy.

# Actions:
# CTRL Del to delete an entry
# ALT  Del to wipe clipboard contents

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
fi

while true; do
    result=$(
  cliphist list | rofi -i -dmenu \
    -kb-custom-1 "Control-Delete" \
    -kb-custom-2 "Alt-Delete" \
    -config ~/.config/rofi/clipboard.rasi
)

case "$?" in
  0)
    [[ -z "$result" ]] && continue
    cliphist decode <<<"$result" | wl-copy
    exit
    ;;
  10)
    cliphist delete <<<"$result"
    ;;
  11)
    cliphist wipe
    ;;
  1)
    exit
    ;;
esac

done
