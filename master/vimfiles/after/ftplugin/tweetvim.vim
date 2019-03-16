" after/ftplugin/tweetvim.vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

nnoremap <silent> <buffer> s          :<C-U>TweetVimSay<CR>
nnoremap <silent> <buffer> <Leader>re :<C-U>TweetVimMentions<CR>

let b:undo_ftplugin .= 'mapc <buffer>'
