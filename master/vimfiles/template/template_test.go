:if expand('%:t:r') !~# '\vexport_%(\w+_)=test'
:  silent /^package\s/s/$/_test/e
:endif
//
// <%= strpart(expand('%:p:h:gs?\\?/?'), len(fnamemodify(getcwd(), ':h')) + 1) %> :: <%= expand('%:t') %>
//
//   Copyright (c) <%= strftime('%Y') %> <%= g:user.format() %>
//

package <%= expand('%:p:h:t:s?^.\{-}\ze\w*$??') %>

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
