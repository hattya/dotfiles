" after/ftplugin/json.vim

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal expandtab
setlocal fileformat=unix
setlocal shiftwidth=2
setlocal tabstop=2

let b:undo_ftplugin .= 'setl et< ff< sw< ts<'
