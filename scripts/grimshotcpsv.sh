#!/usr/bin/env bash

filename="$HOME/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"

# Changed "kill $pid" to "kill -9 $pid" to instantly destroy the overlay surface
area=$(wayfreeze & pid=$!; sleep 0.05; slurp; kill -9 $pid 2>/dev/null) || exit 1

grim -g "$area" - | tee "$filename" | wl-copy --type image/png
