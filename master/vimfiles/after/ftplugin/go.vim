" after/ftplugin/go.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

setlocal fileformat=unix
setlocal tabstop=4

let b:undo_ftplugin .= 'setl ts<'

if g:vimrc.has_plugin('flap.vim')
  let b:flap = {
  \  'rules': [
  \    ['true', 'false'],
  \  ]
  \}
endif

if g:vimrc.has_plugin('vim-lsp')
  augroup vimrc-ft-go
    autocmd! * <buffer>
    autocmd BufWritePre <buffer> call execute('LspDocumentFormatSync') | call execute('LspCodeActionSync source.organizeImports')
  augroup END
endif
