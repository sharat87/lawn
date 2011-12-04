#!/usr/bin/python
#-*- coding:utf-8 -*-

from __future__ import print_function

from fabric.api import task, local
import os, os.path as p
from fabric.contrib.console import confirm
from repo_cmds import wget_cmd
from parex import TaskManager

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

def dln(src, dst=None):
    if dst is None:
        dst = '~/.' + src

    dst = os.path.expanduser(dst)

    if os.path.exists(dst):
        local('mv "' + dst + '" _originals')

    local('ln -s "' + os.path.abspath(src) + '" "' + dst + '"')
