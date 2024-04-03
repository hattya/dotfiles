:silent %s/<+PACKAGE+>/\=expand('%:p:h:t')/ge
#! /usr/bin/env python
#
# setup.py -- <+PACKAGE+> setup script
#

from setuptools import setup, Extension

setup(
    ext_modules=[Extension('<+CURSOR+>',
                           include_dirs=[],
                           sources=[])],
)
