# .config/zsh/.zprofile

umask 022

# start keychain
keys="id_rsa EC917A6D"

if ! whence -p keychain >/dev/null; then
    # keychain is not found
    :
elif [[ ${+SSH_TTY} == 0 ]]; then
    # login via tty
    eval $(keychain --eval --ignore-missing ${=keys})
elif [[ ${SHLVL} == 1 && "${TTY}" == "${SSH_TTY}" ]]; then
    # login via ssh
    eval $(keychain --eval --inherit any-once --ignore-missing ${=keys})
else
    for p in ~/.keychain/"$(hostname)"-sh*(Nr); do
        . "${p}"
    done
fi

uname -snrv
echo "uptime:$(uptime)"
echo
