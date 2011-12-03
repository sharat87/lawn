#!/usr/bin/python
#-*- coding:utf-8 -*-

from fabric.api import *
import os
import os.path as p
from fabric.contrib.console import confirm
from repo_cmds import get_repo_cmd, wget_cmd
from parex import TaskManager

@task(default=True)
def up():

    if os.path.exists('_originals'):
        print '_originals already exists. Delete it first, if you do not need it.'
        if confirm('Get rid of it?'):
            local('rm -Rf _originals')
        else:
            raise SystemExit(1)
    else:
        os.mkdir('_originals')

    DOTFILES = os.path.expanduser('~/dotfiles')

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

    print 'Finished setting up links'

    # TODO: Create a better way to manage these sub repos

    t = TaskManager()
    cmds = {}

    @t.on_process_done
    def on_done(pid, data):
        print '-' * 70, cmds[pid], pid
        print data.getvalue() if data else None

    update_entries = (
        'repo | ssh://hg@bitbucket.org/sjl/hg-prompt                         | hg/hg-prompt',
        'repo | ssh://hg@bitbucket.org/tksoh/hgshelve                        | hg/hg-shelve',
        'repo | git://github.com/altercation/mutt-colors-solarized.git       | mutt/solarized-colors',
        'repo | git://github.com/nicolas33/offlineimap.git                   | mail/offlineimap',
        'wget | https://bitbucket.org/sharat87/dtime/raw/tip/dtime           | ~/bin/dtime',
        'wget | http://betterthangrep.com/ack-standalone                     | ~/bin/ack',
        'wget | https://github.com/technomancy/leiningen/raw/stable/bin/lein | ~/bin/lein',
        'wget | http://releases.clojure-cake.org/cake                        | ~/bin/cake',
        'wget | https://bitbucket.org/sjl/t/raw/tip/t.py                     | ~/.t.py',
        'wget | https://github.com/sjl/z-zsh/raw/master/z.sh                 | shell/custom-configs/sjl-z.sh',
        'repo | git clone git@github.com:sharat87/oh-my-zsh.git              | shell/oh-my-zsh',
        'repo | https://github.com/zsh-users/zsh-syntax-highlighting.git     | shell/custom-configs/plugins/zsh-syntax-highlighting',
    )

    for entry in update_entries:
        method, url, dst = (e.strip() for e in entry.split('|'))
        dst = p.expanduser(dst)
        cmd_fn = {
            'repo': get_repo_cmd,
            'wget': wget_cmd,
        }[method]
        name, cmd = cmd_fn(url, dst=dst)
        pid = t.execute(cmd)
        cmds[pid] = name

    t.wait()
    print 'Finished'

    with lcd('shell/oh-my-zsh'):
        local('rm -Rfv custom')
        local('ln -sv ../custom-configs custom')

def dln(src, dst=None):
    if dst is None:
        dst = '~/.' + src

    dst = os.path.expanduser(dst)

    if os.path.exists(dst):
        local('mv "' + dst + '" _originals')

    local('ln -s "' + os.path.abspath(src) + '" "' + dst + '"')
