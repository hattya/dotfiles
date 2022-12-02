" after/ftplugin/c.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

setlocal expandtab
setlocal shiftwidth=4

let g:c_gnu = 1
let g:c_comment_strings = 1
let g:c_space_errors = 1

let b:undo_ftplugin .= 'setl et< sw< ts<'
let b:undo_ftplugin .= ' | unl g:c_gnu g:c_comment_strings g:c_space_errors'
