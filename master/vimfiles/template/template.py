#! /usr/bin/env python
#
# <%= expand('%:r:gs?\\?/?:gs?/?.?') %>
#
#   Copyright (c) <%= strftime('%Y') %> <%= g:user.format() %>
#

import os
import sys


def main(argv):
    <+CURSOR+>
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
