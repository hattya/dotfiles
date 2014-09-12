# .config/zsh/.zshrc

eval "$(dircolors -b)"
for dc in ~/.dir_colors /etc/DIR_COLORS; do
  if [[ -f ${dc} ]]; then
    eval "$(dircolors -b ${dc})"
    break
  fi
done
unset dc

if whence -p tput >/dev/null; then
  (( is_256color = $(tput colors) == 256 ))
elif [[ ${TERM} == *256color ]]; then
  (( is_256color = 1 ))
fi

function _zshrc-fg() {
  local -a c256 c8
  c256=(${(s.:.)1})
  c8=(${(s.:.)2})
  shift 2
  if (( ${+is_256color} )); then
    if (( ${#c256} == 1 )); then
      echo -n "%F{${c256[1]}}${@}%f"
    else
      echo -n "%(?.%F{${c256[1]}}.%F{${c256[2]}})${@}%f"
    fi
  else
    if (( ${#c8} == 1 )); then
      echo -n "%{${fg[${c8[1]}]}%}${@}%{${reset_color}%}"
    else
      echo -n "%{%(?.${fg[${c8[1]}]}.${fg[${c8[2]}]})%}${@}%{${reset_color}%}"
    fi
  fi
}

# autoload
autoload -Uz add-zsh-hook
autoload -Uz colors;   colors
autoload -Uz compinit; compinit -d "${ZCACHEDIR}"/zcompdump

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
zstyle ':completion:*' cache-path "${ZCACHEDIR}"/zcompcache
zstyle ':completion:*' completer _oldlist _complete _match _history _approximate _prefix
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' use-cache true
zstyle ':completion:*:descriptions' format "$(_zshrc-fg 246 white '-') $(_zshrc-fg 220 yellow '%d') $(_zshrc-fg 246 white '-')"
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

HISTFILE="${ZCACHEDIR}"/zsh_history
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

autoload -Uz vcs_info
add-zsh-hook precmd vcs_info
zstyle ':vcs_info:*' formats " $(_zshrc-fg 214 magenta '(%b)')"

case ${UID} in
0)
  PROMPT="%{${fg[red]}%}%n%{${reset_color}%} %{%(?.${fg[yellow]}.${fg[magenta]})%}%#%{${reset_color}%} "
  ;;
*)
  if [[ $(hostname -i) == 192.168.* ]]; then
    mc=(014 cyan)
  else
    mc=(015 white)
  fi
  m="@%m"
  if (( ${+STY} )); then
    # screen window number
    m+="[${WINDOW}]"
  elif (( ${+TMUX} )); then
    # tmux window number
    function _zshrc-tmux-window() {
      tmux display-message -p "#I.#P"
    }
    m+="[\$(_zshrc-tmux-window)]"
  fi
  PROMPT="$(_zshrc-fg 047 green '%n')$(_zshrc-fg ${mc[@]} "${m}")\${vcs_info_msg_0_} $(_zshrc-fg 228:198 yellow:red '%#') "
  unset m mc
  ;;
esac
RPROMPT=" $(_zshrc-fg 228 yellow '<%~>')"

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

# change window title of terminal
if (( ${+DISPLAY} || ${+SSH_CLIENT} )); then
  case ${TERM} in
  rxvt*|*term*|putty*)
    function _zshrc-update-title() {
      print -n "\e]2;${1}\a"
    }
    ;;
  screen*)
    function _zshrc-update-title() {
      # screen location
      print -n "\e_${1}\e\\"
      # screen title (in ^A)
      [[ -n ${2} ]] && print -n "\ek${2}\e\\"
    }
    ;;
  *)
    function _zshrc-update-title() {
      :
    }
    ;;
  esac

  function _zshrc-chpwd() {
    _zshrc-update-title "$(print -Pn "%n@%m - %~")"
  }
  add-zsh-hook chpwd _zshrc-chpwd

  function _zshrc-preexec() {
    local -a cmd
    cmd+=${(z)1}
    # builtin jobs
    local job
    case ${cmd[1]} in
    fg)
      if (( ${#cmd} == 1 )); then
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
    _zshrc-update-title "$(print -Pn "%n@%m") - ${cmd[1]:t}"
  }
  add-zsh-hook preexec _zshrc-preexec
fi

if [[ -f /usr/share/knu-z/knu-z.sh ]]; then
  export _Z_DATA=~/.cache/z
  . /usr/share/knu-z/knu-z.sh
fi
