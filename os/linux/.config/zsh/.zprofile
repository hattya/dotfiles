# $ZDOTDIR/.zprofile

umask 022

# Gentoo overwrites PATH in /etc/zsh/zprofile
if [[ -f /etc/gentoo-release ]]; then
  . "${ZDOTDIR}"/.zshenv
fi

# start keychain
if (( ${+commands[keychain]} )); then
  if (( ! ${+SSH_TTY} )) || [[ ${SHLVL} -eq 1 && ${TTY} == ${SSH_TTY} ]]; then
    # login via TTY or SSH
    eval $(keychain --eval --ignore-missing --inherit any-once id_ed25519)
  fi
fi

uname -snrv
print "uptime:$(uptime)\n"
