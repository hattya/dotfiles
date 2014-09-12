# $ZDOTDIR/.zshenv

export ZCACHEDIR=~/.cache/zsh

typeset -U path manpath
path+=(~/.local/bin(N/))
manpath+=(/usr/share/man/ja(N/))

# locale
export LANG='ja_JP.UTF-8'
export LC_MESSAGES='C'

export VTE_CJK_WIDTH=1

# basic
export EDITOR=$(whence -p vim)
export PAGER=$(whence -p less)

if whence -p repoman >/dev/null; then
  export ECHANGELOG_USER='Akinori Hattori <hattya@gentoo.org>'
  export PORTAGE_GPG_KEY='EC917A6D'
fi

# less
export LESS='-M -R -X -f -i'
export LESSCOLOR='yes'
if whence -p pygmentize >/dev/null; then
  export LESSCOLORIZER='pygmentize -O encoding=utf-8 -O style=monokai -f 256'
fi
export LESSHISTFILE='-'

# lv
export LV='-c -l'

# Python
export PYTHONSTARTUP=~/.config/python/startup.py

# Go
if [[ -d ~/.local/Cellar/go/tip ]]; then
  path+=(~/.local/Cellar/go/tip/bin(N/))
fi
if whence -p go >/dev/null; then
  export GOPATH=~/.local/go
  path+=({$(go env GOROOT),${GOPATH}}/bin(N/))
fi
