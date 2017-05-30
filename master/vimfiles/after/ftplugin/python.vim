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

let b:undo_ftplugin .= 'setl et< ff< sw< ts<'

let g:python_highlight_all = 1

let s:script = expand('<sfile>:p:r') . '.py'
if has('python3')
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

function! s:pth(activate)
  execute printf('%s _vimrc_pth(int(vim.eval("a:activate")))', has('python3') ? 'python3' : 'python')
endfunction

let b:undo_ftplugin .= ' | execute "autocmd! vimrc-ft-python * <buffer>"'
let b:undo_ftplugin .= ' | call <SNR>' . s:sid . '_pth(0)'
