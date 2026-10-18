#!/usr/bin/env bash
# Media OSD with album art
# Usage: osd_media.sh {--play-pause|--next|--prev|--stop}
# Needs: playerctl, libnotify (notify-send), curl (for remote art)

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/osd-art"
MAX_LINE=34          # cap per line (chars); lower it if your popup is narrow, raise it if wide
mkdir -p "$CACHE_DIR"

# ---------- helpers ----------

notify() {
    local icon="$1" title="$2" body="$3"
    notify-send \
        -a "OSD" \
        -u low \
        -t 2500 \
        -h string:x-canonical-private-synchronous:sys-osd \
        -h string:x-dunst-stack-tag:sys-osd \
        -i "$icon" \
        "$title" "$body"
}

# Escape characters that notification daemons treat as markup
esc() { local s="$1"; s="${s//&/&amp;}"; s="${s//</&lt;}"; s="${s//>/&gt;}"; printf '%s' "$s"; }

# Trim whitespace
trim() { local s="$1"; s="${s#"${s%%[![:space:]]*}"}"; s="${s%"${s##*[![:space:]]}"}"; printf '%s' "$s"; }

# Cap length with an ellipsis (only kicks in for really long strings)
clip() {
    local s="$1"
    (( ${#s} > MAX_LINE )) && s="${s:0:MAX_LINE-1}…"
    printf '%s' "$s"
}

lower() { printf '%s' "${1,,}"; }

# Turn an mpris:artUrl into a local file path (empty if unavailable)
resolve_art() {
    local url="$1" path hash
    [[ -z "$url" ]] && return

    case "$url" in
        file://*)
            path="${url#file://}"
            path="$(printf '%b' "${path//%/\\x}")"   # url-decode
            [[ -f "$path" ]] && echo "$path"
            ;;
        http://*|https://*)
            hash=$(printf '%s' "$url" | md5sum | cut -d' ' -f1)
            path="$CACHE_DIR/$hash"
            if [[ ! -s "$path" ]]; then
                curl -fsL --max-time 1 -o "$path.tmp" "$url" 2>/dev/null \
                    && mv "$path.tmp" "$path" \
                    || rm -f "$path.tmp"
            fi
            [[ -s "$path" ]] && echo "$path"
            ;;
        /*)
            [[ -f "$url" ]] && echo "$url"
            ;;
    esac
}

# Trim cached art older than a week (cheap, runs in background)
( find "$CACHE_DIR" -type f -mtime +7 -delete 2>/dev/null & )

snapshot() {
    playerctl metadata --format "{{ artist }} - {{ title }}|{{ mpris:artUrl }}" 2>/dev/null
}

# ---------- action ----------

action="$1"

old_status=$(playerctl status 2>/dev/null)
old_meta=$(snapshot)

case "$action" in
    --play-pause) playerctl play-pause ;;
    --next)       playerctl next ;;
    --prev)       playerctl previous ;;
    --stop)       playerctl stop ;;
    *)
        echo "Usage: $0 {--play-pause|--next|--prev|--stop}"
        exit 1
        ;;
esac

# Poll briefly for playerctl to catch up (track/status change is async)
for ((i=0; i<100; i++)); do
    status=$(playerctl status 2>/dev/null)
    meta=$(snapshot)

    case "$action" in
        --play-pause) [[ "$status" != "$old_status" && -n "$status" ]] && break ;;
        --next|--prev) [[ "$meta" != "$old_meta" && "$meta" != " - |" ]] && break ;;
        --stop) [[ "$status" == "Stopped" || -z "$status" ]] && break ;;
    esac

    sleep 0.01
done

# Players often update title first and artist/art a moment later — let them settle
if [[ "$action" == "--next" || "$action" == "--prev" ]]; then
    sleep 0.15
fi

# ---------- gather track info ----------

if [[ -z "$status" ]]; then
    notify "dialog-information" "No Active Player" ""
    exit 0
fi

title=$(trim "$(playerctl metadata title 2>/dev/null)")
artist=$(trim "$(playerctl metadata artist 2>/dev/null)")
album=$(trim "$(playerctl metadata album 2>/dev/null)")
album_artist=$(trim "$(playerctl metadata xesam:albumArtist 2>/dev/null)")
art_url=$(playerctl metadata mpris:artUrl 2>/dev/null)
player=$(playerctl -l 2>/dev/null | head -n1 | cut -d. -f1)

# Fallback for players that leave the artist empty
[[ -z "$artist" ]] && artist="$album_artist"

# ---------- clean up / dedupe ----------
# Some players stuff "Artist - Title" into the title, or repeat the title
# in the artist/album field. Make sure each piece shows up at most once.

lt=$(lower "$title"); la=$(lower "$artist"); lal=$(lower "$album")

# Title like "Artist - Song" → strip the artist prefix
if [[ -n "$artist" && "$lt" == "$la - "* ]]; then
    title="${title:$(( ${#artist} + 3 ))}"
    lt=$(lower "$title")
fi

# Artist identical to (or containing) the title → drop it
if [[ -n "$artist" && ( "$la" == "$lt" || "$la" == *"$lt" ) && -n "$lt" ]]; then
    artist=""; la=""
fi

# Album identical to the title (singles) or to the artist → drop it
[[ -n "$album" && ( "$lal" == "$lt" || "$lal" == "$la" ) ]] && album=""

[[ -z "$title" ]] && title="Unknown Track"

# ---------- build text ----------
# Layout (always the same shape):
#   summary:  ▶ Spotify          (state + player)
#   body:     **Title**
#             Artist
#             Album              (only when it adds info)
# The title lives in the body (wraps) instead of the summary (gets "…" cut).

art=$(resolve_art "$art_url")

case "$status" in
    Playing) fallback="media-playback-start"; prefix="" ;;
    Paused)  fallback="media-playback-pause"; prefix="⏸ " ;;
    Stopped) fallback="media-playback-stop";  prefix="" ;;
    *)       fallback="dialog-error";         prefix="" ;;
esac

icon="${art:-$fallback}"

if [[ "$status" == "Stopped" ]]; then
    notify "$icon" "Stopped" ""
    exit 0
fi

# Compact on purpose: song name on top, artist underneath. Nothing else.
# (Status is shown only when paused, as a small ⏸ in front of the title.)
summary="$prefix$(clip "$title")"
body=""
[[ -n "$artist" ]] && body="$(esc "$(clip "$artist")")"

notify "$icon" "$summary" "$body"
