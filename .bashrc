#!/usr/bin/env bash
fastfetch
# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return ;;
esac

alias grep='grep -i --color'
alias ls='eza -a -l --icons'
export PATH=$PATH:/home/walid/.local/scripts:/home/walid/.local/bin:/opt/android-sdk/platform-tools/:/home/walid/.cargo/bin
export GDK_SCALE=1
export GDK_DPI_SCALE=1
export QT_SCALE_FACTOR=1
export EDITOR="nvim"
export NNN_OPENER=xdg-open
export GTK_THEME=Adwaita:dark
export OLLAMA_NUM_GPU=1
export OLLAMA_GPU_OVERHEAD=0

# Catppuccin Macchiato Colors
LAVENDER="\[\e[38;2;183;189;248m\]"
BLUE="\[\e[38;2;138;173;244m\]"
MAUVE="\[\e[38;2;198;160;246m\]"
PINK="\[\e[38;2;245;189;230m\]"
GREEN="\[\e[38;2;166;218;149m\]"
TEXT="\[\e[38;2;202;211;245m\]"
RESET="\[\e[0m\]"

parse_git_branch() {
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  [ -n "$branch" ] && echo " $branch"
}

PS1="${LAVENDER}\u${RESET}@${PINK}\h ${BLUE}\w${RESET} ${GREEN}\$(parse_git_branch)${RESET}\n${GREEN}\$${RESET} "

extract-smart() {
    file="$1"
    [ -f "$file" ] || return 1

    name="$(basename "$file")"
    dir="${name%.*}"

    tmp="$(mktemp -d)"
    7z x "$file" -o"$tmp" >/dev/null

    entries=$(ls -1 "$tmp")
    count=$(echo "$entries" | wc -l)

    if [ "$count" -eq 1 ] && [ -d "$tmp/$entries" ]; then
        mv "$tmp/$entries" .
    else
        mkdir -p "$dir"
        mv "$tmp"/* "$dir"
    fi

    rm -rf "$tmp"
}

extract() {
  if [[ "$1" == "-d" || "$1" == "--dir" ]]; then
    shift
    if [ ! -f "$1" ]; then
      echo "'$1' is not a valid file"
      return 1
    fi
    dir="${1%.*}"  # remove extension for folder name
    mkdir -p "$dir" && cd "$dir" || return
    extract "$1"   # call extract recursively in new folder
    cd - > /dev/null
    return
  fi

  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xvjf "$1"    ;;
      *.tar.gz)    tar xvzf "$1"    ;;
      *.tar.xz)    tar xvJf "$1"    ;;
      *.lzma)      unlzma "$1"      ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xvf "$1"     ;;
      *.tbz2)      tar xvjf "$1"    ;;
      *.tgz)       tar xvzf "$1"    ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *.xz)        unxz "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

export PATH=$PATH:/home/walid/.spicetify
. "$HOME/.cargo/env"
