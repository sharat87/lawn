#!/usr/bin/python
#-*- coding:utf-8 -*-

from __future__ import print_function

from fabric.api import task, local, lcd
import os, os.path as p
from fabric.contrib.console import confirm
from parex import TaskManager
from collections import namedtuple

Subrepo = namedtuple('Subrepo', 'location vcs repo')

@task(default=True)
def put():

    if p.exists('_originals'):
        print('_originals already exists. Delete it first, if you do not need it.')
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
    )

    for entry in update_entries:
        url, dst = (e.strip() for e in entry.split('|'))
        dst = p.expanduser(dst)
        name, cmd = wget_cmd(url, dst=dst)
        pid = t.execute(cmd)
        cmds[pid] = name

    t.wait()

    do_compilations()

    print('Finished')

@task
def up():
    subs = (parse_subrepo(line) for line in  open('.hgsub')
            if not line.isspace() and not line.startswith('#'))

    for sub in subs:
        update_subrepo(sub)

    do_compilations()

def dln(src, dst=None):
    if dst is None:
        dst = '~/.' + src

    dst = p.expanduser(dst)

    if p.exists(dst):
        local('mv "' + dst + '" _originals/')

    local('ln -s "' + p.abspath(src) + '" "' + dst + '"')

def wget_cmd(url, dst=None):
    if dst is None:
        dst = p.basename(url)

    cmd = 'wget --no-check-certificate -O "' + dst + '" "' + url + '"'

    return p.basename(dst), cmd

def parse_subrepo(line):
    location, repo = line.split('=', 1)

    location = location.strip()
    repo = repo.strip()

    if repo.startswith('['):
        vcs, repo = repo[1:].split(']', 1)
    else:
        vcs = 'hg'

    return Subrepo(location, vcs, repo)

def update_subrepo(sub):
    print(p.basename(sub.location))
    with lcd(sub.location):
        if sub.vcs == 'hg':
            local('hg pull -u')
        elif sub.vcs == 'git':
            local('git pull')
        elif sub.vcs == 'svn':
            local('svn up')
        else:
            print('Unknown version control system:', sub.vcs)

def do_compilations():
    if p.exists('vim/ipi/Command-T'):
        with lcd('vim/ipi/Command-T/ruby/command-t'):
            local('ruby extconf.rb')
            local('make')
