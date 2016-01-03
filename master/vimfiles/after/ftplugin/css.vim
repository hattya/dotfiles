" after/ftplugin/css.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

setlocal expandtab
setlocal shiftwidth=2
setlocal tabstop=2
setlocal nowrap

let b:undo_ftplugin .= 'setl et< sw< ts< wrap<'
