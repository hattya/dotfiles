#! /bin/sh

export LANG=ja_JP.UTF-8
unset LC_COLLATE
unset LC_MESSAGES

[ -f ~/.Xmodmap ]    && xmodmap     ~/.Xmodmap
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

# keychain
export SSH_ASKPASS=ssh-askpass-fullscreen
eval $(keychain --eval --ignore-missing id_ed25519)

exec startxfce4

# vim:et:ft=sh
