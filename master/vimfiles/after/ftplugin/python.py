# after/ftplugin/python.py

import io
import os
import re
import sys

import vim


_vimrc_pth_re = re.compile(r'[\s,]')


def _vimrc_pth(activate):
    def find(path, cands):
        while True:
            for n in cands:
                pth = os.path.join(path, n)
                if os.path.isfile(pth):
                    return pth
            path, p = os.path.dirname(path), path
            if path == p:
                return

    def repl(m):
        s = m.group(0)
        return '\\' * (3 if s.isspace() else 2) + s

    cands = ['.pth']
    if sys.platform == 'win32':
        cands.insert(0, '_pth')
    pth = find(os.path.dirname(vim.current.buffer.name) or os.getcwd(), cands)
    if pth:
        root = os.path.dirname(pth)
        values = {'pyver': '{}.{}'.format(*sys.version_info)}
        i = 1 if 'jedi.api' in sys.modules else 0
        with io.open(pth, encoding='utf-8-sig') as fp:
            for l in fp:
                l = os.path.expandvars(l.strip().format(**values))
                p = os.path.normpath(os.path.join(root, l))
                if not os.path.isdir(p):
                    continue
                elif activate:
                    if p not in sys.path:
                        sys.path.insert(i, p)
                        i += 1
                else:
                    if p in sys.path:
                        sys.path.remove(p)

    path = [_vimrc_pth_re.sub(repl, p) for p in sys.path if os.path.isdir(p)]
    vim.command('setlocal path=.,{},,'.format(','.join(path)))
    if 'setl path<' not in vim.eval('b:undo_ftplugin'):
        vim.command('let b:undo_ftplugin .= " | setl path<"')
