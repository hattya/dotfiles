# $ZDOTDIR/.zshenv

export ZCACHEDIR=~/.cache/zsh

typeset -U path save_path userpath manpath
userpath+=(~/.local{,/Cellar/*}/bin(N/))
save_path=(${path})
path=(${userpath} ${path})

manpath+=(/usr/share/man/ja(N/))

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

# Python
export PYTHONSTARTUP=~/.config/python/startup.py

# Go
if (( ${+commands[go]} )); then
  export GOPATH=~/.local/go
  userpath+=({$(go env GOROOT),${GOPATH}}/bin(N/))
fi

# themis.vim
userpath+=(~/.vim/bundle/vim-themis/bin(N/))

path=(${userpath} ${save_path})
unset save_path userpath
