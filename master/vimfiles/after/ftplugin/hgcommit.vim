" after/ftplugin/hgcommit.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

let &l:fileencoding = $HGENCODING !=# '' ? $HGENCODING : 'utf-8'
setlocal spell

let b:undo_ftplugin .= 'setl fenc< spell<'
