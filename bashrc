[ -z "$PS1" ] && return

export HISTSIZE=30000
export HISTFILESIZE=30000
export HISTCONTROL=ignoredups # don't put duplicate lines in the history
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT='%Y/%m/%d %H:%M '
export HISTIGNORE='&:ls:ll:la:cd:exit:clear:history'
# export LANG=en_US.UTF-8
# export LC_ALL=en_US.utf

export VBOX_LOG_DEST=nofile
export EDITOR=vim
export MPD_PORT=8888
export MPD_HOST=localhost

set bell-style none
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

function __git_dirty {
  git diff --quiet HEAD &>/dev/null
  # [[ $? == 1 ]] && echo "♨"
  [[ $? == 1 ]] && echo "⚐"
}

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '○'
}

# export PS1='\u\[\e[1;31m\]@\[\e[0m\]\H in \[\033[1;32m\]\w\[\033[0m\]\[\033[0;36m\]$(__git_ps1 " at (%s)")\[\033[0m\]$(__git_dirty "(%s) ") \[\033[1;33m\]$(prompt_char)\[\033[0m\] '
export PS1='\u\[\e[1;31m\]@\[\e[0m\] in \[\033[1;32m\]\w\[\033[0m\]\[\033[0;36m\]$(__git_ps1 " at (%s)")\[\033[0m\]$(__git_dirty "(%s) ") \[\033[1;33m\]$(prompt_char)\[\033[0m\] '
# export PS1='\[\e[0;32m\]\w\[\e[0m\]$(__git_ps1 " (%s)")
# • '
