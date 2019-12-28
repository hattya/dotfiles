" after/ftplugin/go.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

setlocal tabstop=4

let b:undo_ftplugin .= 'setl ts<'

if g:vimrc.has_plugin('vim-lsp')
  let s:undo_lsp = g:vimrc.lsp()
  if s:undo_lsp !=# ''
    let b:undo_ftplugin .= ' | ' . s:undo_lsp
  endif
endif
