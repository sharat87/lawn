
from __future__ import print_function

from fabric.api import *
import fabric.colors as co
import os, os.path as p
from parex import TaskManager

# Some nice plugins not included
# - Command-T

PLUGIN_REPOS = (r for r in '''

git://github.com/tpope/vim-pathogen.git

git://github.com/altercation/vim-colors-solarized.git

git://github.com/tpope/vim-surround.git
git://github.com/tpope/vim-abolish.git
git://github.com/mileszs/ack.vim.git
git://github.com/vim-scripts/AutoClose.git
git://github.com/vim-scripts/DirDiff.vim.git
git://github.com/tpope/vim-fugitive.git
git://github.com/michaeljsmith/vim-indent-object.git
git://github.com/vim-scripts/matchit.zip.git
git://github.com/tpope/vim-repeat.git
git://github.com/tomtom/tcomment_vim.git
git://github.com/tpope/vim-unimpaired.git
git://github.com/vim-scripts/ZoomWin.git
git://github.com/vim-scripts/ManPageView.git
git://github.com/tpope/vim-markdown.git
git://github.com/ehamberg/vim-cute-python.git
git://github.com/pangloss/vim-javascript.git
git://github.com/vim-scripts/Mark.git
git://github.com/vim-scripts/MarkLines.git
#git://github.com/vim-scripts/vorax.git
git://github.com/kchmck/vim-coffee-script.git

# This one's original repo is bzr based
git://github.com/vim-scripts/UltiSnips.git
#git@github.com:sharat87/snipmate.vim.git

git://github.com/vim-scripts/FuzzyFinder.git

# dependency for the previous one
git://github.com/vim-scripts/L9.git

#git://github.com/vim-scripts/cvsmenu.vim-updated.git
git://github.com/vim-scripts/vcscommand.vim.git

git://github.com/scrooloose/nerdtree.git

# https://sharat87@github.com/sharat87/sessionman.vim.git
git://github.com/sharat87/sessionman.vim.git

https://bitbucket.org/sharat87/vim-looks

git://github.com/vim-scripts/Conque-Shell.git

git://github.com/vim-scripts/vimwiki.git

# have to force clone this one
https://bitbucket.org/kotarak/vimclojure force-clone

git://github.com/tpope/vim-ragtag.git

https://bitbucket.org/sjl/gundo.vim

git://github.com/Shougo/vimproc.git

git://github.com/ujihisa/quickrun.git

'''.splitlines() if r and not r.startswith('#'))

@task
def up():

    if not p.exists('bundle'):
        os.mkdir('bundle')

    repos = map(lambda r: get_repo_cmd(r, cwd='bundle'), PLUGIN_REPOS)

    procs = {}

    t = TaskManager(cwd='bundle')

    print(co.yellow('Starting...'))
    for plugin, cmd in repos:
        pid = t.execute(cmd)
        procs[pid] = plugin
        print(plugin + ', ', end='')
    print(co.yellow('Running'))

    t.wait()
    print(co.yellow('Finished'))

    with lcd('bundle'):
        print(co.blue('Running custom commands'))

        with lcd('vimclojure'):
            local('cp -R vim/* .')

        with lcd('vimproc'):
            local('make -f make_gcc.mak')

        print(co.yellow('Finished'))

    for pid, data in t.data.items():
        plugin = procs[pid]
        print(co.green(plugin), co.blue('@' + str(pid)), data.getvalue().strip())

    clean_unused_plugins(procs.values())

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

def clean_unused_plugins(plugins):
    all_plugins = set(os.listdir('bundle'))
    unused_plugins = all_plugins - set(plugins)

    with lcd('bundle'):
        for p in unused_plugins:
            print(co.red('rm ' + p))
            local('rm -Rf ' + p)
