#!/bin/sh

selection="$(cliphist list | rofi -dmenu \
  -p ' clipboard' \
  -theme-str '
configuration {
    show-icons: false;
    sidebar-mode: false;
}
* {
    font: "JetBrainsMono Nerd Font 12";
    bg: #1e1e2e;
    bg-alt: #181825;
    fg: #cdd6f4;
    fg-alt: #7f849c;
    accent: #89b4fa;
}
window {
    width: 45%;
    location: center;
    anchor: center;
    background-color: @bg;
    border-radius: 18px;
}
mainbox {
    padding: 18px;
}
inputbar {
    children: [prompt, entry];
    background-color: @bg-alt;
    border-radius: 12px;
    padding: 10px;
}
entry {
    placeholder: "search clipboard…";
}
listview {
    lines: 8;
    spacing: 6px;
    padding: 6px 0;
}
element {
    padding: 10px;
    border-radius: 12px;
}
element selected {
    background-color: @accent;
    text-color: @bg;
}
'
)"

[ -n "$selection" ] && cliphist decode <<< "$selection" | wl-copy

