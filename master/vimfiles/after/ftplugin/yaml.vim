" after/ftplugin/yaml.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

setlocal expandtab
setlocal tabstop=2
setlocal shiftwidth=2

let b:undo_ftplugin .= 'setl et< ts< sw<'
