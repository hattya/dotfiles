# $ZDOTDIR/.zprofile

umask 022

# Gentoo overwrites PATH in /etc/zsh/zprofile
if [[ -f /etc/gentoo-release ]]; then
  . "${ZDOTDIR}"/.zshenv
fi

# start keychain
if (( ${+commands[keychain]} )) && [[ -t 0 ]]; then
  if (( ! ${+SSH_TTY} )) || [[ ${SHLVL} -eq 1 && ${SSH_TTY} == ${TTY} ]]; then
    # wipe invalid PID files
    (
      for f in ~/.keychain/"$(hostname)"-sh(N); do
        . "${f}"
        if ! kill -0 ${SSH_AGENT_PID} >/dev/null 2>&1; then
          rm -f ~/.keychain/"$(hostname)"-*(N)
        fi
      done
    )
    # login via TTY or SSH
    eval $(keychain --eval --ignore-missing --ssh-allow-forwarded id_ed25519)
  fi
fi

uname -snrv
print "uptime:$(uptime)\n"
