" after/ftplugin/python.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

setlocal expandtab
setlocal fileformat=unix
setlocal shiftwidth=4
setlocal tabstop=4

let g:python_highlight_all = 1

let b:undo_ftplugin .= 'setl et< ff< sw< ts<'
let b:undo_ftplugin .= ' | unl g:python_highlight_all'

let s:script = expand('<sfile>:p:r') . '.py'
if has('pythonx')
  execute 'pyxfile ' . s:script
elseif has('python3')
  execute 'py3file ' . s:script
elseif has('python')
  execute 'pyfile ' . s:script
else
  finish
endif

function! s:sid() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction
let s:sid = s:sid()

augroup vimrc-ft-python
  autocmd! * <buffer>
  autocmd BufEnter <buffer> call s:pth(1)
  autocmd BufLeave <buffer> call s:pth(0)
augroup END

function! s:pth(activate) abort
  execute printf('python%s _vimrc_pth(int(vim.eval("a:activate")))', has('pythonx') ? 'x' : has('python3') ? '3' : '')
endfunction

let b:undo_ftplugin .= ' | exe "au! vimrc-ft-python * <buffer>"'
let b:undo_ftplugin .= ' | cal <SNR>' . s:sid . '_pth(0)'

if g:vimrc.has_plugin('flap.vim')
  let b:flap = {
  \  'rules': [
  \    ['True', 'False'],
  \    ['Spam', 'Eggs', 'Ham', 'Toast', 'Beans', 'Bacon', 'Sausage', 'Tomato', 'Lobster', 'Shallots', 'Aubergine', 'Truffle', 'Pate', 'Shrubbery', 'Herring', 'Blancmange'],
  \    ['spam', 'eggs', 'ham', 'toast', 'beans', 'bacon', 'sausage', 'tomato', 'lobster', 'shallots', 'aubergine', 'truffle', 'pate', 'shrubbery', 'herring', 'blancmange'],
  \  ],
  \}
endif
