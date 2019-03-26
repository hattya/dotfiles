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

    if activate:
        cands = ['.pth']
        if sys.platform == 'win32':
            cands.insert(0, '_pth')
        pth = find(os.path.dirname(vim.current.buffer.name) or os.getcwd(), cands)
        pth_path = []
        if pth:
            root = os.path.dirname(pth)
            values = {'pyver': '{}.{}'.format(*sys.version_info)}
            with io.open(pth, encoding='utf-8-sig') as fp:
                for l in fp:
                    l = os.path.expandvars(l.strip().format(**values))
                    p = os.path.normpath(os.path.join(root, l))
                    if (os.path.isdir(p)
                        and p not in sys.path):
                        pth_path.append(p)
        # for Jedi
        m = sys.modules.get('jedi.api.project')
        if m is not None:
            m.discover_buildout_paths = lambda *a, **kw: pth_path
        # setlocal path
        path = [_vimrc_pth_re.sub(repl, p) for p in sys.path + pth_path if os.path.isdir(p)]
        vim.command('setlocal path=.,{},,'.format(','.join(path)))
        if 'setl path<' not in vim.eval('b:undo_ftplugin'):
            vim.command('let b:undo_ftplugin .= " | setl path<"')
    else:
        proj = sys.modules.get('jedi.api.project')
        path = sys.modules.get('jedi.evaluate.sys_path')
        if (proj is not None
            and path is not None):
            proj.discover_buildout_paths = path.discover_buildout_paths
