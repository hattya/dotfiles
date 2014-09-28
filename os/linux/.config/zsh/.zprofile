# $ZDOTDIR/.zprofile

umask 022

# Gentoo overwrites PATH in /etc/zsh/zprofile
if [[ -f /etc/gentoo-release ]]; then
  . "${ZDOTDIR}"/.zshenv
fi

# start keychain
keys=(id_rsa EC917A6D)
if (( ${+commands[keychain]} )); then
  if (( ! ${+SSH_TTY} )); then
      # login via tty
      eval $(keychain --eval --ignore-missing ${keys[@]})
  elif [[ ${SHLVL} -eq 1 && ${TTY} == ${SSH_TTY} ]]; then
      # login via ssh
      eval $(keychain --eval --ignore-missing --inherit any-once ${keys[@]})
  fi
fi
unset keys

uname -snrv
print "uptime:$(uptime)\n"
