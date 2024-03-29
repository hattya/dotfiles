# $ZDOTDIR/.zshenv

export ZCACHEDIR=~/.cache/zsh

typeset -U path save_path userpath manpath
userpath+=(~/.local{,/Cellar/*}/bin(N/))
save_path=(${path})
path=(${userpath} ${path})

# locale
export LANG='ja_JP.UTF-8'
export LC_MESSAGES='C'

export VTE_CJK_WIDTH=1

# basic
export EDITOR=${commands[vim]}
export PAGER=${commands[less]}

if (( ${+commands[repoman]} )); then
  export ECHANGELOG_USER='Akinori Hattori <hattya@gentoo.org>'
  export PORTAGE_GPG_KEY='EC917A6D'
fi

# via SSH
if (( ${+SSH_CONNECTION} )); then
  # D-Bus
  if (( ! ${+DBUS_SESSION_BUS_ADDRESS} )) && [[ -e ${XDG_RUNTIME_DIR}/bus ]]; then
    export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
  fi
fi

# Docker
export DOCKER_BUILDKIT=1

# GnuPG
export GPG_TTY=$(tty)

# Go
if (( ${+commands[go]} )); then
  export GOPATH=~/.local
  userpath+=($(go env GOROOT)/bin(N/))
fi

# less
export LESS='-M -R -X -f -i'
export LESSHISTFILE='-'
if (( ${+commands[pygmentize]} )); then
  export LESSCOLORIZER='pygmentize -O encoding=utf-8 -O style=monokai -f 256'
fi
if [[ -f /etc/gentoo-release ]]; then
  export LESSCOLOR='yes'
elif [[ -f /etc/debian_version ]]; then
  export LESSOPEN='| lesspipe %s'
fi

# lv
export LV='-c -l'

# Node.js
if (( ${+commands[n]} )); then
  export N_PREFIX=~/.local/Cellar/node
fi

# Python
export PYTHONSTARTUP=~/.config/python/startup.py

# themis.vim
userpath+=(~/.vim/bundle/vim-themis/bin(N/))
export THEMIS_ARGS='--clean -e -s'

path=(${userpath} ${save_path})
unset save_path userpath
