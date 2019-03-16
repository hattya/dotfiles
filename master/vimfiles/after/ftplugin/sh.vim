" after/ftplugin/sh.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

setlocal expandtab
setlocal shiftwidth=2
setlocal tabstop=2

let g:is_bash = 1

let b:undo_ftplugin .= 'setl et< sw< ts<'
let b:undo_ftplugin .= ' | unl g:is_bash'
