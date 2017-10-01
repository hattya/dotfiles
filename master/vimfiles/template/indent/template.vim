:silent %s,<+LANGUAGE+>,\=expand('%:p:r:gs?\\?/?:s?.*/indent/\([^/]\+\).*?\u\1?'),ge
" Vim indent file
" Language:    <+LANGUAGE+>
" Author:      <%= g:user.format() %>
" Last Change: 
" License:     

if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

setlocal indentexpr=Get<+LANGUAGE+>Indent()

let b:undo_indent = 'setlocal indentexpr<'

if exists('*Get<+LANGUAGE+>Indent')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

function! Get<+LANGUAGE+>Indent() abort
  <+CURSOR+>
  return -1
endfunction

if exists('*shiftwidth')
  let s:sw = function('shiftwidth')
else
  function! s:sw()
    return &sw
  endfunction
endif

let &cpo = s:save_cpo
unlet s:save_cpo
