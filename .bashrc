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
  local b state gitdir

  # Get git dir
  gitdir=$(git rev-parse --git-dir 2>/dev/null) || return

  # Branch or commit
  b=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) || b=$(git rev-parse --short HEAD 2>/dev/null) || return

  # Detect state
  if [[ -d "$gitdir/rebase-merge" || -d "$gitdir/rebase-apply" ]]; then
    state="|rebase"
  elif [[ -f "$gitdir/MERGE_HEAD" ]]; then
    state="|merge"
  elif [[ -f "$gitdir/CHERRY_PICK_HEAD" ]]; then
    state="|cherry-pick"
  elif [[ -f "$gitdir/REVERT_HEAD" ]]; then
    state="|revert"
  elif [[ -f "$gitdir/BISECT_LOG" ]]; then
    state="|bisect"
  fi

  printf '(%s%s)' "$b" "$state"
}

# Prompt
PS1='\[\033[32m\][\[\033[33m\]\W\[\033[32m\]]\[\033[38;5;11m\]$(git_branch)\[\033[32m\]\$ \[\033[0m\]'

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
