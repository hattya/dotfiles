" after/ftplugin/unite.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

nnoremap <buffer> <expr> <C-T> unite#do_action('tabopen')
inoremap <buffer> <expr> <C-T> unite#do_action('tabopen')

let b:undo_ftplugin .= 'mapc <buffer> | imapc <buffer>'
