:if expand('%:t:r') !~# '\vexport_%(\w+_)=test'
:  silent /^package\s/s/$/_test/e
:endif
//
// <%= expand('%:p:h:t') %> :: <%= expand('%:t') %>
//
//   Copyright (c) <%= strftime('%Y') %> <%= g:user.format() %>
//

package <%= expand('%:p:h:t:s?^go[-.]??') %>

import (
	"testing"
)

func Test<+CURSOR+>(t *testing.T) {
	t.Fail()
}

func Benchmark(b *testing.B) {
	for i := 0; i < b.N; i++ {
	}
}
