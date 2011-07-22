#!/usr/bin/env python

from __future__ import print_function

import os
import os.path as p

def get_repo_cmd(url, dst=None, dvcs=None, cwd=''):

    force_clone = False
    if 'force-clone' in url:
        url = url.replace('force-clone', '').strip()
        force_clone = True

    if dst is None:
        dst = os.path.basename(url)
        if dst.endswith('.git'):
            dst = dst[:-4]

    dst = p.abspath(p.expanduser(p.join(cwd, dst)))

    if dvcs is None:
        if 'github' in url:
            dvcs = 'git'
        else:
            dvcs = 'hg'

    if p.isdir(dst) and force_clone:
        local('rm -Rf ' + dst)

    if p.isdir(dst):
        cmd = 'cd ' + dst + '&& ' + dvcs + (' fetch' if dvcs == 'hg' else ' pull')
    else:
        cmd = dvcs + ' clone "' + url + '"' + ('' if dst is None else ' "' + dst + '"')

    return p.basename(dst), cmd

def wget_cmd(url, dst=None):
    if dst is None:
        dst = os.path.basename(url)

    cmd = 'wget --no-check-certificate -O "' + dst + '" "' + url + '"'

    return p.basename(dst), cmd

if __name__ == '__main__':
    raise SystemExit('Intended only to be used as a module')
