:silent %s/<+PACKAGE+>/\=expand('%:p:h:t')/ge
:if isdirectory('tests')
:  silent /#\s*>>*\s*discover/+2,/#\s*<<*\s*discover/-1s/#\s//
:  silent g/#\s*[<>]\+\s*discover/d
:else
:  silent /#\s*>>*\s*simple/+2,/#\s*<<*\s*simple/-1s/#\s//
:  silent g/#\s*[<>]\+\s*simple/d
:endif
:silent g/#\s*>>*\s*\w\+/,/#\s*<<*\s*\w\+/d
#! /usr/bin/env python
#
# setup.py -- <+PACKAGE+> setup script
#

import os
import sys

from setuptools import setup, Command


class test(Command):

    description = 'run unit tests'
    user_options = [('failfast', 'f', 'stop on first fail or error')]

    boolean_options = ['failfast']

    def initialize_options(self):
        self.failfast = False

    def finalize_options(self):
        pass

    def run(self):
        import unittest

        self.run_command('egg_info')
        # >>> simple
        # run unittest
        # argv = [sys.argv[0]]
        # if self.verbose:
        #     argv.append('--verbose')
        # if self.failfast:
        #     argv.append('--failfast')
        # unittest.main('test_<+PACKAGE+>', argv=argv)
        # <<< simple
        # >>> discover
        # run unittest discover
        # argv = [sys.argv[0], 'discover', '--start-directory', 'tests']
        # if self.verbose:
        #     argv.append('--verbose')
        # if self.failfast:
        #     argv.append('--failfast')
        # unittest.main(None, argv=argv)
        # <<< discover


cmdclass = {
    'test': test,
}

<+CURSOR+>
setup(cmdclass=cmdclass,
      entry_points={
          'console_scripts': [
              '<+PACKAGE+> = <+PACKAGE+>.cli:run',
          ]
      },
      scmver={
          'root': os.path.dirname(os.path.abspath(__file__)),
          'spec': 'micro',
          'write_to': os.path.join('<+PACKAGE+>', '__version__.py'),
          'fallback': ['__version__:version', '<+PACKAGE+>'],
      })
