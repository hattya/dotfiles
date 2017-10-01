" Vim filetype plugin file
" Language:    <%= expand('%:p:r:gs?\\?/?:s?.*/ftplugin/\([^/]\+\).*?\u\1?') %>
" Author:      <%= g:user.format() %>
" Last Change: 
" License:     

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

let s:save_cpo = &cpo
set cpo&vim

<+CURSOR+>

let b:undo_ftplugin = ''

let &cpo = s:save_cpo
unlet s:save_cpo
