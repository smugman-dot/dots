#!/bin/bash

filename="$HOME/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"
area=$(slurp)

# Take screenshot and save
grim -g "$area" "$filename"

# Copy to clipboard
cat "$filename" | wl-copy

# Optional notify
notify-send "Screenshot saved and copied" "$filename"

