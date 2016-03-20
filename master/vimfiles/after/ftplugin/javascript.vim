" after/ftplugin/javascript.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

setlocal expandtab
setlocal fileformat=unix
setlocal shiftwidth=2
setlocal tabstop=2
if g:vimrc.has_plugin('jscomplete-vim')
  setlocal omnifunc=jscomplete#CompleteJS
endif

let b:undo_ftplugin .= 'setl et< ff< ofu< sw< ts<'
