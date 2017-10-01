#
# <%= expand('%:t:r:gs?\\?/?') %>
#
#   Copyright (c) <%= strftime('%Y') %> <%= g:user.format() %>
#

import unittest


class <%= expand('%:t:r:s?test??:gs?_\+\(\l\)?\u\1?') %>TestCase(unittest.TestCase):

    def test_(self):
        <+CURSOR+>
        self.assertTrue(0)
