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
try
  call jscomplete#CompleteJS(1, '')

  setlocal omnifunc=jscomplete#CompleteJS
catch /:E117:.*/
endtry

let b:undo_ftplugin .= 'setl et< ff< ofu< sw< ts<'
