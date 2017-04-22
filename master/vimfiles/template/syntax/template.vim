" Vim syntax file
" Language:    <%= substitute(expand('%:t:r'), '\v^(.)', '\u\1', '') %>
" Author:      <%= g:user.format() %>
" Last Change: 
" License:     

if exists('b:current_syntax')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

<+CURSOR+>

let b:current_syntax = '<%= expand("%:t:r") %>'

let &cpo = s:save_cpo
unlet s:save_cpo
