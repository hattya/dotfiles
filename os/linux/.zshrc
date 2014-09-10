# .zshrc

typeset -U path manpath
path+=(~/.local/bin(N/))
manpath+=(/usr/share/man/ja(N/))

eval "$(dircolors -b)"
for dc in ~/.dir_colors /etc/DIR_COLORS; do
  if [[ -f ${dc} ]]; then
    eval "$(dircolors -b ${dc})"
    break
  fi
done
unset dc

# autoload
autoload -Uz colors;   colors
autoload -Uz compinit; compinit

# chdir
setopt auto_cd
setopt auto_pushd
setopt cdable_vars
setopt pushd_ignore_dups
setopt pushd_silent
setopt pushd_to_home

# completion
setopt complete_aliases
setopt complete_in_word
setopt glob_complete
setopt menu_complete
setopt rec_exact

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' completer _oldlist _complete _match _history _approximate _prefix
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}'
zstyle ':completion:*' menu select=2
zstyle ':completion:*:descriptions' format "- %{${fg[yellow]}%}%d%{${reset_color}%} -"
# processes
zstyle ':completion:*:processes' command "ps -au '${USER}' -o pid,tty,cputime,args"
zstyle ':completion:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.*' insert-sections true
# sudo
zstyle ':completion:*:sudo:*' command-path {/usr/local,/usr,}/{s,}bin

# glob
setopt extended_glob
setopt mark_dirs

# history
setopt extended_history
setopt hist_fcntl_lock
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt share_history

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# io
unsetopt clobber
setopt correct
setopt correct_all
setopt ignore_eof

# job
setopt auto_resume
setopt long_list_jobs
setopt notify

# prompt
setopt prompt_subst
setopt transient_rprompt

case ${UID} in
0)
  PROMPT="%{${fg_bold[red]}%}%n %{${fg_bold[yellow]}%}%#%{${reset_color}%} "
  ;;
*)
  if [[ $(hostname -i) == 192.168.* ]]; then
    m="cyan"
  else
    m="white"
  fi
  m="%{${fg_bold[${m}]}%}@%m"
  if [[ ${+STY} == 1 ]]; then
    # screen window number
    m+="[${WINDOW}]"
  elif [[ ${+TMUX} == 1 ]]; then
    # tmux window number
    function _zshrc_tmux_window() {
      tmux display-message -p "#I.#P"
    }
    m+="[\$(_zshrc_tmux_window)]"
  fi
  PROMPT="%{${fg_bold[green]}%}%n${m} %{%(?.${fg_bold[green]}.${fg_bold[red]})%}%(?.:).:() %{${fg_bold[yellow]}%}%#%{${reset_color}%} "
  unset m
  ;;
esac
RPROMPT=" %{${fg_bold[yellow]}%}<%~>%{${reset_color}%}"

# zle
unsetopt beep

# key bindings
bindkey -e
autoload -Uz select-word-style
select-word-style bash

# global aliases
alias -g C='| cut'
alias -g G='| grep'
alias -g H='| head'
alias -g L='| less'
alias -g S='| sort'
alias -g T='| tail'
alias -g U='| uniq'
alias -g W='| wc'

# aliases
alias ls='ls -Fh --color=auto --time-style=long-iso'
alias ll='ls -l'
alias la='ls -lA'

alias pu=pushd
alias po=popd

if whence -p emacs >/dev/null; then
  alias emacs='XMODIFIERS="@im=none" emacs'
fi

if whence -p bpython >/dev/null; then
  alias bp2=bpython-2.7
  alias bp3=bpython-$(python3 -c 'import sys; print(sys.version[:3])')
  alias bp=bp3
fi

function tmux() {
  if [[ ${#} -ge 1 && ${1} == -z ]]; then
    shift
    if ! tmux has-session &>/dev/null; then
      command tmux new-session -d
      command tmux rename-window work \; \
                   new-window -d -n root 'su -' \; \
                   swap-window -s 1 \; \
                   new-window -d -t 5 top
      if [[ $(command tmux show-options -g) == *pane-border-ascii* ]]; then
        command tmux set-option -gq pane-border-ascii on 
      fi
    fi
    command tmux attach-session -d "${@}"
  else
    command tmux "${@}"
  fi
}

# environment variables
export LANG='ja_JP.UTF-8'
export LC_MESSAGES='C'
export EDITOR=$(which -p vim)
export PAGER=$(which -p less)
export LESS='-M -R -X -f -i'
export LESSCOLOR='yes'
if whence -p pygmentize &>/dev/null; then
  export LESSCOLORIZER='pygmentize -O encoding=utf-8 -O style=monokai -f 256'
fi
export LESSHISTFILE='-'
export LV='-c -l'
export PYTHONSTARTUP=~/.config/python/startup.py
export VTE_CJK_WIDTH=1
# Gentoo Linux
if [[ -f /etc/gentoo-release ]]; then
  export ECHANGELOG_USER='Akinori Hattori <hattya@gentoo.org>'
  export PORTAGE_GPG_KEY='EC917A6D'
fi
# Go
if [[ -d ~/.local/Cellar/go/tip ]]; then
  path+=(~/.local/Cellar/go/tip/bin(N/))
fi
if whence -p go >/dev/null; then
  export GOPATH=~/.local/go
  path+=({$(go env GOROOT),${GOPATH}}/bin(N/))
fi

# change window title of terminal
autoload -Uz add-zsh-hook
if [[ ${+DISPLAY} == 1 || ${+SSH_CLIENT} == 1 ]]; then
  case ${TERM} in
  rxvt*|*term*|putty*)
    function _zshrc_update_title() {
      print -n "\e]2;${1}\a"
    }
    ;;
  screen*)
    function _zshrc_update_title() {
      # screen location
      print -n "\e_${1}\e\\"
      # screen title (in ^A)
      [[ -n ${2} ]] && print -n "\ek${2}\e\\"
    }
    ;;
  *)
    function _zshrc_update_title() {
      :
    }
    ;;
  esac

  function _zshrc_chpwd() {
    _zshrc_update_title "$(print -Pn "%n@%m - %~")"
  }
  add-zsh-hook chpwd _zshrc_chpwd

  function _zshrc_preexec() {
    local -a cmd
    cmd+=${(z)1}
    # builtin jobs
    local job
    case ${cmd[1]} in
    fg)
      if [[ ${#cmd} == 1 ]]; then
        job="%+"
      else
        job="${cmd[2]}"
      fi
      ;;
    %*)
      job=${cmd[1]}
      ;;
    esac
    if [[ -n ${job} ]]; then
      cmd=($(builtin jobs -l ${job} 2>/dev/null))
      if [[ ${cmd[5]} == "(signal)" ]]; then
        cmd=(${cmd[6,${#cmd}]})
      else
        cmd=(${cmd[5,${#cmd}]})
      fi
    fi

    [[ -z ${cmd} ]] && cmd+=${(z)1}
    _zshrc_update_title "$(print -Pn "%n@%m") - ${cmd[1]:t}"
  }
  add-zsh-hook preexec _zshrc_preexec
fi

if [[ -f /usr/share/knu-z/knu-z.sh ]]; then
  export _Z_DATA=~/.cache/z
  . /usr/share/knu-z/knu-z.sh
fi
