:silent %s/<+NAME+>/\=expand('%:t:r')/ge
" File:        <%= expand('%:p:gs?\\?/?:s?.*/\%(\.vim\|vimfiles\)/??') %>
" Author:      <%= g:user.format() %>
" Last Change: 
" License:     

if exists('g:loaded_<+NAME+>')
  finish
endif
let g:loaded_<+NAME+> = 1

let s:save_cpo = &cpo
set cpo&vim

<+CURSOR+>

augroup <+NAME+>
  autocmd!
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
