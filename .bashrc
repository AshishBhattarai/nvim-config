# ~/.bashrc

# Exit if not interactive
[[ $- != *i* ]] && return

# History settings
HISTCONTROL=ignoredups:erasedups
HISTSIZE=50000
HISTFILESIZE=100000
shopt -s histappend

# Helpers
add_to_path() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

# NVM
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"

# Optional local deps
[[ -f "$HOME/Documents/deps/deps.sh" ]] && source "$HOME/Documents/deps/deps.sh"

# Git branch for prompt
git_branch() {
  local b
  b=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) &&
    printf '(%s)' "$b" ||
    git branch --no-color 2>/dev/null | sed -n 's/^\* \(.*\)$/\1/p'
}

# Prompt
PS1='\[\e[32m\][\[\e[33m\]\W\[\e[32m\]]\[\033[38;5;11m\]$(git_branch)\[\e[32m\]\$ \[\e[0m\]'

# Custom env vars
export JS_DEBUG_PATH="$HOME/Documents/deps/js-debug/dist/src/dapDebugServer.js"
export NEORG_NOTES_REPO="$HOME/Documents/notes/"

# PNPM
export PNPM_HOME="$HOME/.local/share/pnpm"
add_to_path "$PNPM_HOME"

# fzf
command -v fzf >/dev/null 2>&1 && eval "$(fzf --bash)"

# Local bin
add_to_path "$HOME/.local/bin"

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias codex='firejail codex'
