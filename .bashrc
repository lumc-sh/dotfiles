#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto -A'
alias ll='ls -lstrh'
alias scrot='scrot ~/Pictures/Screenshots/%c.png'
alias history-clear='history -c && history -w'
alias shred='shred -uz -n 2'
alias pqiv='pqiv -i'


BROWSER=/usr/bin/firefox
EDITOR=/usr/bin/emacs

# Prompt
. ~/.git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
GIT='$(__git_ps1 " (%s)") '
BLUE='\[\033[01;34m\]'
GREEN='\[\033[01;32m\]'
GREY='\[\033[01;37m\]'
DEFAULT='\[\033[00m\]'
PS1="$GREEN\u$GREY@$GREEN\h $BLUE\w$GREY$GIT$GREY\$$DEFAULT "

# HSTR configuration - add this to ~/.bashrc
alias hh=hstr                    # hh to be alias for hstr
export HSTR_CONFIG='hicolor raw-history-view'
shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
# ensure synchronization between bash memory and history file
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
# if this is interactive shell, then bind 'kill last command' to Ctrl-x k
if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi
export HSTR_TIOCSTI=y
