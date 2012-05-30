#!/usr/bin/env python
# encoding: utf-8

from __future__ import print_function
from __future__ import unicode_literals

from fabric.api import task, local, lcd
import os
from os.path import expanduser, basename, exists, abspath
from fabric.contrib.console import confirm
from parex import TaskManager

TOOLS = [
    ('https://bitbucket.org/sharat87/dtime/raw/tip/dtime', '~/bin/dtime'),
    ('http://betterthangrep.com/ack-standalone', '~/bin/ack'),
    ('https://github.com/technomancy/leiningen/raw/stable/bin/lein', '~/bin/lein'),
    ('https://github.com/flatland/cake/raw/develop/bin/cake', '~/bin/cake'),
    ('https://raw.github.com/holman/spark/master/spark', '~/bin/spark'),
    ('https://bitbucket.org/sjl/t/raw/tip/t.py', '~/.t.py'),
    ('https://raw.github.com/samirahmed/fu/master/src/fu.py', '~/bin/fu'),
    ('https://raw.github.com/fireteam/curlish/master/curlish.py', '~/bin/curlish'),
]

@task(default=True)
def put():

    if exists('_originals'):
        print('_originals already exists.'
                ' Delete it first, if you do not need it.')
        if confirm('Get rid of it?'):
            local('rm -Rf _originals')
        else:
            raise SystemExit(1)

    os.mkdir('_originals')

    dln('tmux.conf')

    dln('mail/offlineimap.conf', '~/.offlineimaprc')
    dln('mutt/muttrc', '~/.muttrc')

    dln('fabricrc')
    dln('toprc')

    dln('pentadactylrc')

    dln('nautilus-scripts', '~/.gnome2/nautilus-scripts')

    dln('web/js', '~/.js')
    dln('web/css', '~/.css')

    dln('git/config', '~/.gitconfig')
    dln('git/ignore', '~/.gitignore')

    dln('hg/hgrc', '~/.hgrc')

    dln('shell/zsh', '~/.zshrc')
    dln('shell/env', '~/.zshenv')

    dln('shell/bash', '~/.bashrc')

    local('mkdir -p shell/custom-configs/plugins')

    print('Finished setting up links')

    tools()

@task
def tools():
    t = TaskManager()
    cmds = {}

    @t.on_process_done
    def on_done(pid, data):
        print('-' * 70, cmds[pid], pid)
        print(data.getvalue() if data else None)

    for url, dst in TOOLS:
        pid = t.execute('wget --no-check-certificate '
                '-O "' + expanduser(dst) + '" "' + url + '"')
        cmds[pid] = basename(dst)

    t.wait()

    do_compilations()

    print('Finished updating tools')

@task
def up():
    local('git submodule foreach git pull')
    local('vim +BundleInstall! +qall')
    do_compilations()
    tools()

def dln(src, dst=None):
    if dst is None:
        dst = '~/.' + src

    dst = expanduser(dst)

    if exists(dst):
        local('mv "' + dst + '" _originals/')

    local('ln -s "' + abspath(src) + '" "' + dst + '"')

def do_compilations():
    if exists('vim/ipi/Command-T'):
        with lcd('vim/ipi/Command-T/ruby/command-t'):
            local('ruby extconf.rb')
            local('make')
