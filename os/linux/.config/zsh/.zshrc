# $ZDOTDIR/.zshrc

eval "$(dircolors -b)"
for dc in ~/.dir_colors /etc/DIR_COLORS; do
  if [[ -f ${dc} ]]; then
    eval "$(dircolors -b "${dc}")"
    break
  fi
done
unset dc

if (( ${+commands[tput]} )); then
  (( has_256color = $(tput colors) == 256 ))
elif [[ ${TERM} == *256color ]]; then
  (( has_256color = 1 ))
fi

zshrc-fg() {
  local -a c256 c8
  c256=(${(s.:.)1})
  c8=(${(s.:.)2})
  shift 2
  if (( has_256color )); then
    if (( ${#c256} == 1 )); then
      print -n "%F{${c256[1]}}${@}%f"
    else
      print -n "%(?.%F{${c256[1]}}.%F{${c256[2]}})${@}%f"
    fi
  else
    if (( ${#c8} == 1 )); then
      print -n "%{${fg_bold[${c8[1]}]}%}${@}%{${reset_color}%}"
    else
      print -n "%{%(?.${fg_bold[${c8[1]}]}.${fg_bold[${c8[2]}]})%}${@}%{${reset_color}%}"
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
zstyle ':completion:*:descriptions' format "$(zshrc-fg 246 white '-') $(zshrc-fg 220 yellow '%d') $(zshrc-fg 246 white '-')"
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
zstyle ':vcs_info:*' formats " $(zshrc-fg 214 magenta '(%b)')"
zstyle ':vcs_info:*' actionformats " $(zshrc-fg 214 magenta '(%b:%a)')"

case ${UID} in
0)
  PROMPT="%{${fg_bold[red]}%}%n%{${reset_color}%} %{%(?.${fg_bold[yellow]}.${fg_bold[magenta]})%}%#%{${reset_color}%} "
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
    zshrc-tmux-window() {
      tmux display-message -p "#I.#P"
    }
    m+="[\$(zshrc-tmux-window)]"
  fi
  PROMPT="$(zshrc-fg 047 green '%n')$(zshrc-fg ${mc[@]} "${m}")\${vcs_info_msg_0_} $(zshrc-fg 228:198 yellow:red '%#') "
  unset m mc
  ;;
esac
RPROMPT=" $(zshrc-fg 228 yellow '<%~>')"

# zle
unsetopt beep

# key bindings
bindkey -e
if [[ ${TERM} != emacs ]]; then
  typeset -A map
  map=(
    khome beginning-of-line
    kich1 overwrite-mode
    kdch1 delete-char
    kend  end-of-line
    kpp   beginning-of-buffer-or-history
    knp   end-of-buffer-or-history
  )
  for k in ${(k)map}; do
    if [[ -n ${terminfo[${k}]} ]]; then
      bindkey -M emacs "${terminfo[${k}]}" "${map[${k}]}"
    fi
  done
  unset map
fi

autoload -Uz select-word-style
select-word-style bash

if (( ${+commands[peco]} )); then
  zshrc-peco-history-search() {
    local tac
    if (( ${+commands[tac]} )); then
      tac="tac"
    else
      tac="tail -r"
    fi

    BUFFER="$(fc -ln 1 | ${tac} | awk '!a[$0]++' | peco --query "${LBUFFER}")"
    CURSOR=${#BUFFER}
  }
  zle -N zshrc-peco-history-search
  bindkey '^R' zshrc-peco-history-search
fi

# global aliases
alias -g A='| awk'
alias -g C='| cut'
alias -g G='| grep'
alias -g H='| head'
alias -g L='| less'
alias -g S='| sort'
alias -g T='| tail'
alias -g U='| uniq'
alias -g W='| wc'
alias -g X='| xargs'

# aliases
if (( ${+commands[emacs]} )); then
  alias emacs='XMODIFIERS="@im=none" emacs'
fi

alias grep='grep --color=auto'

alias ls='ls -Fh --color=auto --time-style=long-iso'
alias ll='ls -l'
alias la='ls -lA'

alias man='LC_MESSAGES="${LANG}" man'

if (( ${+commands[chg]} )); then
  alias hg='LC_TIME=C chg'
fi

alias pu=pushd
alias po=popd

if (( ${+commands[rg]} )); then
  alias rg='rg --smart-case'
fi

tmux() {
  if [[ ${#} -ge 1 && ${1} == -z ]]; then
    shift
    if ! tmux has-session &>/dev/null; then
      command tmux new-session -d
      command tmux rename-window work \; \
                   new-window -d -n root 'su -' \; \
                   swap-window -s 1
      if (( ${+commands[htop]} )); then
        command tmux new-window -d -t 5 htop -d 10
      else
        command tmux new-window -d -t 5 top
      fi
    fi
    command tmux attach-session -d "${@}"
  else
    command tmux "${@}"
  fi
}

# change window title of terminal
if (( ${+DISPLAY} || ${+SSH_CONNECTION} )); then
  case ${TERM} in
  rxvt*|*term*|putty*)
    zshrc-term-title() {
      print -n "\e]2;${1}\a"
    }
    ;;
  screen*)
    zshrc-term-title() {
      # screen location
      print -n "\e_${1}\e\\"
      # screen title (in ^A)
      [[ -n ${2} ]] && print -n "\ek${2}\e\\"
    }
    ;;
  *)
    zshrc-term-title() {
      :
    }
    ;;
  esac

  zshrc-term-title-chpwd() {
    zshrc-term-title "$(print -Pn "%n@%m - %~")"
  }
  add-zsh-hook chpwd zshrc-term-title-chpwd

  zshrc-term-title-preexec() {
    local -a cmd
    local found=1 i=1 j=-1
    cmd=(${(z)1})
    while (( found )); do
      found=0
      # remove parenthesis
      if [[ ${cmd[i]} == "(" ]]; then
        (( i++ ))
        (( j-- ))
        found=1
      fi
      # skip the environment
      if [[ ${cmd[i]} =~ = && ! ${cmd[i]} =~ ^[./] ]]; then
        (( i++ ))
        found=1
      fi
    done
    cmd=(${cmd[${i},${j}]})
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
      job="${cmd[1]}"
      ;;
    esac
    if [[ -n ${job} ]]; then
      i=5
      cmd=($(builtin jobs -l "${job}" 2>/dev/null))
      if [[ ${cmd[${i}]} == "(signal)" ]]; then
        (( i++ ))
      fi
      cmd=(${cmd[${i},-1]})
    fi

    zshrc-term-title "$(print -Pn "%n@%m - ")${cmd[1]}"
  }
  add-zsh-hook preexec zshrc-term-title-preexec
fi

if (( ${+commands[keychain]} )); then
  # keychain
  zshrc-keychain-preexec() {
    local f
    for f in ~/.keychain/"$(hostname)"-sh*(Nr); do
      . "${f}"
    done
  }
  add-zsh-hook preexec zshrc-keychain-preexec
elif (( ${+TMUX} )); then
  # ssh-agent
  zshrc-tmux-preexec() {
    eval $(tmux show-environment -s)
  }
  add-zsh-hook preexec zshrc-tmux-preexec
fi

if [[ -f ~/.local/Cellar/knu-z/z.sh ]]; then
  export _Z_DATA=~/.cache/z
  . ~/.local/Cellar/knu-z/z.sh
fi

if [[ -f ~/.local/Cellar/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  . ~/.local/Cellar/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
