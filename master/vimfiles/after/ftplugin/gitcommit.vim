" after/ftplugin/gitcommit.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

setlocal fileencoding=utf-8
setlocal spell

let b:undo_ftplugin .= 'setl fenc< spell<'
