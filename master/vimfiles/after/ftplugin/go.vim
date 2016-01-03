" after/ftplugin/go.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

setlocal tabstop=4

let b:undo_ftplugin .= 'setl ts<'

if maparg('<Plug>(go-def-tab)') !=# ''
  map <buffer> gd        <Plug>(go-def-tab)
  map <buffer> <Leader>t <Plug>(go-test)
  map <buffer> <Leader>c <Plug>(go-coverage)
  map <buffer> <Leader>i <Plug>(go-info)

  let b:undo_ftplugin .= ' | mapclear <buffer>'
endif
