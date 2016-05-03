:if expand('%:t:r') =~# 'main'
:  silent /^package\s/s/\s\zs.*$/main/e
:  silent /^func\s/s/\s\zs.*\ze(/main/e
:  call append(line('.'), "\t<+CURSOR+>")
:endif
//
// <%= expand('%:p:h:t') %> :: <%= expand('%:t') %>
//
//   Copyright (c) <%= strftime('%Y') %> <%= g:user.format() %>
//

package <%= expand('%:p:h:t:s?^go[-.]??') %>

import (
	"fmt"
)

func <+CURSOR+>() {
}
