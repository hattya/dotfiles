" after/ftplugin/vim.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

setlocal expandtab
setlocal fileformat=unix
if &foldmethod ==# 'manual'
  setlocal foldmethod=marker
endif
setlocal shiftwidth=2
setlocal tabstop=2

let b:undo_ftplugin .= 'setl et< ff< fdm< sw< ts<'

let g:vim_indent_cont = 0
