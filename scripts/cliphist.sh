#!/bin/sh

selection="$(stash list | fuzzel --dmenu)"
[ -n "$selection" ] && stash decode <<< "$selection" | wl-copy

