" after/ftplugin/dockerfile.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

setlocal expandtab

let b:undo_ftplugin = 'setl et<'
