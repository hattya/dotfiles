" after/ftplugin/rst.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

setlocal expandtab
setlocal shiftwidth=2
setlocal tabstop=2
setlocal spell

let b:undo_ftplugin .= 'setl et< sw< ts< spell<'
