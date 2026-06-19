filename="$HOME/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"
area=$(slurp)

# Take screenshot and save
grim -g "$area" "$filename"

# Copy image to clipboard
wl-copy --type image/png < "$filename"
