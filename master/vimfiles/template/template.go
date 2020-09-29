:if expand('%:t:r') =~# 'main'
:  silent /^package\s/s/\s\zs.*$/main/e
:  silent /^func\s/s/\s\zs.*\ze(/main/e
:  call append(line('.'), "\t<+CURSOR+>")
:endif
//
// <%= strpart(expand('%:p:h:gs?\\?/?'), len(fnamemodify(getcwd(), ':h')) + 1) %> :: <%= expand('%:t') %>
//
//   Copyright (c) <%= strftime('%Y') %> <%= g:user.format() %>
//

package <%= expand('%:p:h:t:s?^.\{-}\ze\w*$??') %>

import (
	"fmt"
)

func <+CURSOR+>() {
}
