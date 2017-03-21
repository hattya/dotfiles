# .hgrc.d/utime.py

import os
import time


def hook(ui, repo, hooktype, **kwargs):
    def utime(name, ts, date):
        p = repo.wjoin(name)
        if os.path.exists(p):
            ui.debug('utime: {} - {}\n'.format(date, name))
            os.utime(p, ts)

    ctx = repo['.']
    m = ctx.manifest()
    s = ctx.status()
    for f in s.modified:
        del m[f]
    r = ctx.rev()
    dirs = {}
    while m:
        ctx = repo[r]
        date = ctx.date()
        ts = (date[0],) * 2
        date = time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(date[0] - date[1]))
        for f in ctx.files():
            if f in m:
                utime(f, ts, date)
                del m[f]

                p = f
                while True:
                    p = os.path.dirname(p)
                    if not p:
                        break
                    elif p not in dirs:
                        dirs[p] = (ts, date)
        r -= 1

    for d in sorted(dirs, reverse=True):
        utime(d, *dirs[d])
