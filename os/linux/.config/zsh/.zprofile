# $ZDOTDIR/.zprofile

umask 022

# start keychain
keys=(id_rsa EC917A6D)
if whence -p keychain >/dev/null; then
  if (( ! ${+SSH_TTY} )); then
      # login via tty
      eval $(keychain --eval --ignore-missing ${keys[@]})
  elif [[ ${SHLVL} -eq 1 && ${TTY} == ${SSH_TTY} ]]; then
      # login via ssh
      eval $(keychain --eval --ignore-missing --inherit any-once ${keys[@]})
  else
      for f in ~/.keychain/"$(hostname)"-sh*(Nr); do
          . "${f}"
      done
      unset f
  fi
fi
unset keys

uname -snrv
print "uptime:$(uptime)\n"
