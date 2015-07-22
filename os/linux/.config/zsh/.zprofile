# $ZDOTDIR/.zprofile

umask 022

# Gentoo overwrites PATH in /etc/zsh/zprofile
if [[ -f /etc/gentoo-release ]]; then
  . "${ZDOTDIR}"/.zshenv
fi

# start keychain
typeset -A keys
keys=(id_rsa ssh EC917A6D gpg)
if (( ${+commands[keychain]} )); then
  if (( ! ${+SSH_TTY} )) || [[ ${SHLVL} -eq 1 && ${TTY} == ${SSH_TTY} ]]; then
    # login via TTY or SSH
    eval $(keychain --agents ${(j:,:)${(@LuOa)keys}} --eval --ignore-missing --inherit any-once ${(@k)keys})
  fi
fi
unset keys

uname -snrv
print "uptime:$(uptime)\n"
