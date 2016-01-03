" after/ftplugin/c.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

setlocal expandtab
setlocal shiftwidth=4
setlocal tabstop=4
setlocal textwidth=79

let b:undo_ftplugin .= 'setl et< sw< ts< tw<'

let g:c_gnu = 1
let g:c_comment_strings = 1
let g:c_space_errors = 1
