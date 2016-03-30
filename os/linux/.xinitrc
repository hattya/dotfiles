#! /bin/sh

export LANG=ja_JP.UTF-8
unset LC_COLLATE
unset LC_MESSAGES

setxkbmap -layout jp -model jp106

[ -f ~/.Xmodmap ]    && xmodmap     ~/.Xmodmap
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

# keychain
export SSH_ASKPASS=ssh-askpass-fullscreen
eval $(keychain --eval --ignore-missing id_rsa EC917A6D)

exec startxfce4 --with-ck-launch

# vim:et:ft=sh
