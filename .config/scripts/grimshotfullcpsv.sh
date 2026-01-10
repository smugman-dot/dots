# Generate filename with timestamp
filename=~/Pictures/full_$(date +%F_%T).png

# Take full-screen screenshot with Grim
grim "$filename"

# Copy to clipboard using wl-copy
wl-copy < "$filename"

