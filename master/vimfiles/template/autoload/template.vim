" File:        <%= expand('%:p:gs?\\?/?:s?.*/\%(\w*\.vim\|vimfiles\)/??') %>
" Author:      <%= g:user.format() %>
" Last Change: 
" License:     

let s:save_cpo = &cpo
set cpo&vim

function! <%= expand('%:p:r:gs?[/\\]?#?:s?.*#autoload#??') %>#<+CURSOR+>() abort
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
