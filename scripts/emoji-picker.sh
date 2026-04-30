#!/usr/bin/env bash
# emoji-picker.sh — fuzzel emoji picker with smart history
# Requires: fuzzel, wl-copy, python3
# Optional: wtype (for --type mode), notify-send

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
EMOJI_JSON="${EMOJI_DB:-$SCRIPT_DIR/emojis.json}"
HISTORY_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/emoji-picker/history.json"

if [[ ! -f "$EMOJI_JSON" ]]; then
    echo "Error: emojis.json not found at: $EMOJI_JSON" >&2
    exit 1
fi

mkdir -p "$(dirname "$HISTORY_FILE")"

# Build fuzzel input via Python:
# - recent/frequent emojis shown first with a ★ marker
# - rest of emojis follow
build_list() {
    python3 - "$EMOJI_JSON" "$HISTORY_FILE" <<'PYEOF'
import sys, json, os, time

emoji_db  = sys.argv[1]
hist_file = sys.argv[2]

with open(emoji_db, encoding="utf-8") as f:
    all_emojis = json.load(f)

# Load history
history = {}
if os.path.exists(hist_file):
    with open(hist_file, encoding="utf-8") as f:
        history = json.load(f)

# Smart frecency score: frequency / (1 + age_in_days)
now = time.time()
def score(entry):
    age_days = (now - entry.get("last_used", 0)) / 86400
    return entry.get("count", 1) / (1 + age_days)

sorted_history = sorted(history.items(), key=lambda x: score(x[1]), reverse=True)
shown = set()

if sorted_history:
    print("── recent ──")
    for char, meta in sorted_history:
        print(f"{char} ★ {meta.get('name', '')}")
        shown.add(char)
    print("── all emojis ──")

for entry in all_emojis:
    if entry["emoji"] not in shown:
        print(f"{entry['emoji']} {entry['name']}")
PYEOF
}

# Run fuzzel
selected=$(
    build_list | fuzzel \
        --dmenu \
        --prompt "  " \
        --font "monospace:size=14" \
        --width 42 \
        --lines 16
)

[[ -z "$selected" ]] && exit 0

# Ignore separator lines
[[ "$selected" == ──* ]] && exit 0

# Extract emoji and name — pass $selected as an argument to avoid quoting hell
read -r emoji name < <(
    python3 - "$selected" <<'PYEOF'
import sys
line = sys.argv[1]
parts = line.split(' ', 1)
emoji = parts[0]
name  = parts[1].lstrip('★ ') if len(parts) > 1 else ''
print(emoji, name)
PYEOF
)

[[ -z "$emoji" ]] && exit 0

# Update history
python3 - "$HISTORY_FILE" "$emoji" "$name" <<'PYEOF'
import sys, json, os, time

hist_file = sys.argv[1]
char      = sys.argv[2]
name      = sys.argv[3]

history = {}
if os.path.exists(hist_file):
    with open(hist_file, encoding="utf-8") as f:
        history = json.load(f)

entry = history.get(char, {"count": 0, "last_used": 0, "name": name})
entry["count"]    += 1
entry["last_used"] = time.time()
entry["name"]      = name
history[char]      = entry

# Cap at 200 entries by frecency score
if len(history) > 200:
    now = time.time()
    def score(e):
        age_days = (now - e.get("last_used", 0)) / 86400
        return e.get("count", 1) / (1 + age_days)
    history = dict(
        sorted(history.items(), key=lambda x: score(x[1]), reverse=True)[:200]
    )

with open(hist_file, "w", encoding="utf-8") as f:
    json.dump(history, f, ensure_ascii=False, indent=2)
PYEOF

# Copy to clipboard
printf '%s' "$emoji" | wl-copy

# Type directly at cursor if --type flag is passed
if [[ "$*" == *--type* ]]; then
    wtype "$emoji"
fi

notify-send "Copied" "$emoji" --expire-time=1500 2>/dev/null
