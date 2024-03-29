" after/ftplugin/html.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

setlocal expandtab
setlocal shiftwidth=2
setlocal tabstop=2
setlocal nowrap

let g:html_indent_script1 = 'zero'

let b:undo_ftplugin .= 'setl et< sw< ts< wrap<'
let b:undo_ftplugin .= ' | unl g:html_indent_script1'
