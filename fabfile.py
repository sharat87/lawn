#!/usr/bin/python
#-*- coding:utf-8 -*-

from fabric.api import *
import os
from fabric.contrib.console import confirm

@task
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

    dln('git/config', '~/.gitconfig')
    dln('git/ignore', '~/.gitignore')

    dln('hg/hgrc', '~/.hgrc')

    dln('shell/zsh', '~/.zshrc')
    dln('shell/env', '~/.zshenv')

    dln('shell/bash', '~/.bashrc')

    print 'Finished setting up links'

    # TODO: Create a better way to manage these sub repos

    repo('http://bitbucket.org/sjl/hg-prompt', 'hg/hg-prompt')
    repo('https://sharat87@bitbucket.org/tksoh/hgshelve', 'hg/hg-shelve')

    repo('git://github.com/altercation/mutt-colors-solarized.git', 'mutt/solarized-colors')

    repo('git://github.com/nicolas33/offlineimap.git', 'mail/offlineimap')

    print 'Finished cloning/upping repositories'

    with lcd('~/bin'):
        wget('http://betterthangrep.com/ack-standalone', 'ack')
        wget('http://stackp.online.fr/wp-content/uploads/droopy')
        wget('https://github.com/technomancy/leiningen/raw/stable/bin/lein')
        wget('http://releases.clojure-cake.org/cake')

    wget('https://bitbucket.org/sjl/t/raw/tip/t.py', os.path.expanduser('~/.t.py'))

    # Stuff that make command line more fun!
    with lcd('shell/custom-configs'):
        wget('https://github.com/sjl/z-zsh/raw/master/z.sh', 'sjl-z.sh')

    # Download oh-my-zsh and set it up
    repo('git clone git@github.com:sharat87/oh-my-zsh.git', 'shell/oh-my-zsh')

    repo('git://github.com/nicoulaj/zsh-syntax-highlighting.git', 'shell/oh-my-zsh/plugins/zsh-syntax-highlighting')

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

def repo(url, dst=None, dvcs=None):

    if dst is None:
        dst = os.path.basename(url)
        if dst.endswith('.git'):
            dst = dst[:-4]

    dst = os.path.abspath(os.path.expanduser(dst))

    if dvcs is None:
        if 'github' in url:
            dvcs = 'git'
        else:
            dvcs = 'hg'

    if os.path.isdir(dst):
        with lcd(dst):
            local(dvcs + (' fetch' if dvcs == 'hg' else ' pull'))
    else:
        local(dvcs + ' clone "' + url + '"' + ('' if dst is None else ' "' + dst + '"'))

def wget(url, dst=None):
    if dst is None:
        dst = os.path.basename(url)

    local('wget --no-check-certificate -O "' + dst + '" "' + url + '"')
