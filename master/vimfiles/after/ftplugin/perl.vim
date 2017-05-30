" after/ftplugin/perl.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

setlocal expandtab
setlocal shiftwidth=4
setlocal tabstop=4

let b:undo_ftplugin .= 'setl et< sw< ts<'
