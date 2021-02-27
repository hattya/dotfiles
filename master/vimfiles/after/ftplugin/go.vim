" after/ftplugin/go.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

setlocal tabstop=4

let b:undo_ftplugin .= 'setl ts<'

if g:vimrc.has_plugin('flap.vim')
  let b:flap = {
  \  'rules': [
  \    ['true', 'false'],
  \  ]
  \}
endif
