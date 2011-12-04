#!/usr/bin/python
#-*- coding:utf-8 -*-

from __future__ import print_function

from fabric.api import task, local, lcd
import fabric.colors as co
import os, os.path as p
from fabric.contrib.console import confirm
from repo_cmds import get_repo_cmd, wget_cmd
from parex import TaskManager

PLUGIN_REPOS = (r.strip() for r in '''

git://github.com/tpope/vim-pathogen.git
git://github.com/altercation/vim-colors-solarized.git

git://github.com/tpope/vim-surround.git
git://github.com/tpope/vim-abolish.git
git://github.com/mileszs/ack.vim.git
git://github.com/vim-scripts/matchit.zip.git
git://github.com/tpope/vim-repeat.git
git://github.com/tpope/vim-unimpaired.git
git://github.com/vim-scripts/ZoomWin.git
git://github.com/tpope/vim-markdown.git
git://github.com/ehamberg/vim-cute-python.git
git://github.com/pangloss/vim-javascript.git
git://github.com/kchmck/vim-coffee-script.git

# Align stuff in a powerful way
git://github.com/godlygeek/tabular.git

# A file browser in vim for nerds
git://github.com/scrooloose/nerdtree.git

# Awesome cool undo tree visualization
https://bitbucket.org/sjl/gundo.vim

# F*ck you auto close plugins. F*ck you with all my might! So very f*ck you!!
# git://github.com/vim-scripts/AutoClose.git
# git://github.com/Raimondi/delimitMate.git
# https://github.com/Townk/vim-autoclose.git
# https://github.com/vim-scripts/ClosePairs.git
https://github.com/vim-scripts/simple-pairs.git
# https://github.com/vim-scripts/Auto-Pairs.git

# Keystroke saving with Vim and Google Scribe
# git://github.com/dubenstein/vim-google-scribe.git

# This one's original repo is bzr based
git://github.com/vim-scripts/UltiSnips.git
#git@github.com:sharat87/snipmate.vim.git

# Highlight several words in different colors simultaneously. (#1238 continued)
git://github.com/vim-scripts/Mark--Karkat.git

# tpope's tiny little commenting plugin
git://github.com/tpope/vim-commentary.git

# Obligatory vcs utils
git://github.com/vim-scripts/vcscommand.vim.git

# have to force clone this one
https://bitbucket.org/kotarak/vimclojure force-clone

# git://github.com/Shougo/vimproc.git
# git://github.com/ujihisa/quickrun.git

# Converts PNG and GIF icons to XPM with ImageMagick when edited in vim
git://github.com/tpope/vim-afterimage.git

# wisely add "end" in ruby, endfunction/endif/more in vim script, etc
git://github.com/tpope/vim-endwise.git

# Syntax checking hacks for vim
git://github.com/scrooloose/syntastic.git

# A vim plugin to perform diffs on blocks of code
git://github.com/AndrewRadev/linediff.vim.git

# on the fly Python checking in Vim with PyFlakes
git://github.com/kevinw/pyflakes-vim.git with-submodules

# Add useful informations to Vim statusline
https://github.com/millermedeiros/vim-statline.git

# Python command :Pyd
git://github.com/vim-scripts/pythondo.git

# The douchebag maintainer of this plugin couldn't keep it as it was and removed the plugin
# Have to checkout git version 4b79c381c3f35e8a61d68cd9e7be9682fb32cfac for a working version
# git://github.com/vim-scripts/ManPageView.git

# Fuzzy file, buffer and MRU file finder with regexp support.
git://github.com/kien/ctrlp.vim.git

# Super text object additions
git://github.com/michaeljsmith/vim-indent-object.git

# A vim script to provide CamelCase motion through words.
git://github.com/bkad/CamelCaseMotion.git

# Check for forgotten attachments when writing a mail
git://github.com/chrisbra/CheckAttach.git

# Vim syntax file for mustache and handlebars(?)
https://github.com/juvenn/mustache.vim.git

# Show relation to search pattern matches in range or buffer.
https://github.com/vim-scripts/SearchPosition.git

# a quick notetaking plugin
https://github.com/fmoralesc/vim-pad.git

# Load plugins individually - cut down start-up time.
https://github.com/jceb/vim-ipi.git

# HTML5 Syntax File
# https://github.com/vim-scripts/HTML5-Syntax-File.git

# HTML5 omnicomplete and syntax
https://github.com/othree/html5.vim.git

# A plug-in for the Vim text editor that provides
# context-sensitive documentation for Python source code.
https://github.com/xolox/vim-pyref.git

# pydoc integration for the best text editor on earth
# https://github.com/fs111/pydoc.vim.git

# Python Omni Completion
https://github.com/vim-scripts/pythoncomplete.git

# vim plugin to interact with the simplenote service
# https://github.com/mrtazz/simplenote.vim.git

# Run interactive commands inside a Vim buffer
https://github.com/vim-scripts/Conque-Shell.git

# Simulating a vaguely WriteRoom-like environment in Vim.
https://github.com/mikewest/vimroom.git

'''.splitlines() if r.strip() and not r.startswith('#'))

@task(default=True)
def up():

    if os.path.exists('_originals'):
        print('_originals already exists. Delete it first, if you do not need it.')
        if confirm('Get rid of it?'):
            local('rm -Rf _originals')
        else:
            raise SystemExit(1)
    else:
        os.mkdir('_originals')

    dln('tmux.conf')

    dln('mail/offlineimap.conf', '~/.offlineimaprc')
    dln('mutt/muttrc', '~/.muttrc')

    dln('fabricrc')
    dln('toprc')

    dln('web/js', '~/.js')
    dln('web/css', '~/.css')

    dln('git/config', '~/.gitconfig')
    dln('git/ignore', '~/.gitignore')

    dln('hg/hgrc', '~/.hgrc')

    dln('shell/zsh', '~/.zshrc')
    dln('shell/env', '~/.zshenv')

    dln('shell/bash', '~/.bashrc')

    if not p.exists('shell/custom-configs/plugins'):
        local('mkdir -p shell/custom-configs/plugins')

    print('Finished setting up links')

    # TODO: Create a better way to manage these sub repos

    t = TaskManager()
    cmds = {}

    @t.on_process_done
    def on_done(pid, data):
        print('-' * 70, cmds[pid], pid)
        print(data.getvalue() if data else None)

    update_entries = (
        'https://bitbucket.org/sharat87/dtime/raw/tip/dtime           | ~/bin/dtime',
        'http://betterthangrep.com/ack-standalone                     | ~/bin/ack',
        'https://github.com/technomancy/leiningen/raw/stable/bin/lein | ~/bin/lein',
        'https://bitbucket.org/sjl/t/raw/tip/t.py                     | ~/.t.py',
        'https://github.com/sjl/z-zsh/raw/master/z.sh                 | shell/custom-configs/sjl-z.sh',
    )

    for entry in update_entries:
        url, dst = (e.strip() for e in entry.split('|'))
        dst = p.expanduser(dst)
        name, cmd = wget_cmd(url, dst=dst)
        pid = t.execute(cmd)
        cmds[pid] = name

    t.wait()
    print('Finished')

    # VIMFILES updating

    if not p.exists('vim/bundle'):
        os.mkdir('vim/bundle')

    if not p.exists('vim/ipi'):
        os.mkdir('vim/ipi')

    repos = []
    for repo in PLUGIN_REPOS:
        cwd = 'vim/bundle'
        if ' deferred' in repo:
            cwd = 'vim/ipi'
            repo = repo.replace(' deferred', '')
        repos.append(get_repo_cmd(repo, cwd=cwd))

    procs = {}

    t = TaskManager(cwd='vim/bundle')

    print(co.yellow('Starting...'))
    for plugin, cmd in repos:
        pid = t.execute(cmd)
        procs[pid] = plugin
        print(plugin + ', ', end='')
    print(co.yellow('Running'))

    @t.on_process_done
    def on_process_done(pid, data):
        print('--', co.green(procs[pid]), co.blue('@' + str(pid)), data.getvalue().strip() if data else None)

    t.wait()
    print(co.yellow('Finished'))

    with lcd('vim/bundle'):
        print(co.blue('Running custom commands'))

        if p.isdir('bundle/vimclojure'):
            with lcd('vimclojure'):
                local('cp -R vim/* .')

        print(co.yellow('Finished'))

    clean_unused_plugins(procs.values())

def dln(src, dst=None):
    if dst is None:
        dst = '~/.' + src

    dst = os.path.expanduser(dst)

    if os.path.exists(dst):
        local('mv "' + dst + '" _originals')

    local('ln -s "' + os.path.abspath(src) + '" "' + dst + '"')

def clean_unused_plugins(plugins):
    all_plugins = set(os.listdir('vim/bundle'))
    unused_plugins = all_plugins - set(plugins)

    with lcd('vim/bundle'):
        for p in unused_plugins:
            print(co.red('rm ' + p))
            local('rm -Rf ' + p)
