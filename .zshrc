# ──────────────────────────────────────────────────────────────────
# ZSH Configuration - Smooth & Minimal
# ──────────────────────────────────────────────────────────────────

if [[ -f /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]]; then
  source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
elif [[ -f ~/.zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]]; then
  source ~/.zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
fi

# Autosuggestions
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Directory Navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Completion System
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ──────────────────────────────────────────────────────────────────
# Colors
# ──────────────────────────────────────────────────────────────────

# Define color palette
typeset -A colors
colors=(
  cyan     '%F{#49BDC7}'
  blue     '%F{#298E82}'
  magenta  '%F{#f5bde6}'
  green    '%F{#a6da95}'
  yellow   '%F{#eed49f}'
  red      '%F{#ed8796}'
  fg       '%F{#cad3f5}'
  gray     '%F{#5b6078}'
  reset    '%f'
)

# ──────────────────────────────────────────────────────────────────
# Prompt
# ──────────────────────────────────────────────────────────────────

setopt PROMPT_SUBST

# Git branch function
git_branch() {
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [[ -n $branch ]]; then
    echo " ${colors[magenta]}󰊢 $branch${colors[reset]}"
  fi
}

# Build prompt
PROMPT='${colors[cyan]}╭─${colors[reset]} ${colors[blue]}%~${colors[reset]}$(git_branch)
${colors[cyan]}╰─${colors[magenta]}❯${colors[reset]} '


RPROMPT='${colors[gray]}%D{%Y-%m-%d %H:%M:%S}${colors[reset]}'

# ──────────────────────────────────────────────────────────────────
# Aliases
# ──────────────────────────────────────────────────────────────────

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# List
alias ls='exa -a -l --icons --color=auto'

alias grep='grep -ai --color=auto'

# ──────────────────────────────────────────────────────────────────
# Functions
# ──────────────────────────────────────────────────────────────────

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract archives
extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# ──────────────────────────────────────────────────────────────────
# Key Bindings
# ──────────────────────────────────────────────────────────────────

bindkey -e  # Emacs mode
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward


bindkey -v  # vim mode
# ──────────────────────────────────────────────────────────────────
# Environment
# ──────────────────────────────────────────────────────────────────

export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'

# LS Colors (matching your theme)
export LS_COLORS='di=1;38;2;73;189;199:fi=0;38;2;202;211;245:ln=0;38;2;245;189;230:ex=1;38;2;166;218;149'

# ──────────────────────────────────────────────────────────────────

fastfetch --config nyarch
