" File:        <%= substitute(expand('%:p:gs?\\?/?'), '\v^.*%(\.vim|vimfiles)/+', '', '') %>
" Author:      <%= g:user.format() %>
" Last Change: 
" License:     

let s:save_cpo = &cpo
set cpo&vim

function! <%= substitute(expand('%:p:r:gs?\\?/?:gs?/?#?'), '^.*autoload#', '', '') %>#<+CURSOR+>() abort
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
