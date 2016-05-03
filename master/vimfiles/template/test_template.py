#
# <%= expand('%:t:r:gs?\\?/?') %>
#
#   Copyright (c) <%= strftime('%Y') %> <%= g:user.format() %>
#

import unittest


class <%= substitute(expand('%:t:r:s?test??'), '\v_+(\l)', '\u\1', 'g') %>TestCase(unittest.TestCase):

    def test_(self):
        <+CURSOR+>
        self.assertTrue(0)
