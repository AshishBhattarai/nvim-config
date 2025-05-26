#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Avoid duplicate entries
HISTCONTROL=ignoredups:erasedups

# Increase limit
HISTSIZE=50000
HISTFILESIZE=100000

# Append history instead of overwriting
shopt -s histappend

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

source $HOME/Documents/deps/deps.sh

git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1="\[\e[m\]\[\e[32m\][\[\e[m\]\[\e[33m\]\W\[\e[m\]\[\e[32m\]]\[\e[m\]\[\e[32m\]\[\033[38;5;11m\]\$(git_branch)\[\e[32m\]\$\[\e[m\] "
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export JS_DEBUG_PATH="/home/ashish/Documents/deps/js-debug/dist/src/dapDebugServer.js"
export NEORG_NOTES_REPO="/home/ashish/Documents/notes/"

# pnpm
export PNPM_HOME="/home/ashish/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

eval "$(fzf --bash)"

export PATH="$PATH:/home/ashish/.local/bin"
