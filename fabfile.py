#!/usr/bin/python
#-*- coding:utf-8 -*-

from fabric.api import *
import os
from fabric.contrib.console import confirm

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

    dln('shell/bash', '~/.bashrc')

    print 'Finished setting up links'

    # TODO: Create a better way to manage these sub repos

    if os.path.isdir('hg/hg-prompt'):
        with lcd('hg/hg-prompt'):
            local('hg fetch')
    else:
        local('hg clone http://bitbucket.org/sjl/hg-prompt hg/hg-prompt')

    if os.path.isdir('hg/hg-shelve'):
        with lcd('hg/hg-shelve'):
            local('hg fetch')
    else:
        local('hg clone https://sharat87@bitbucket.org/tksoh/hgshelve hg/hg-shelve')

    if os.path.isdir('mutt/solarized-colors'):
        with lcd('mutt/solarized-colors'):
            local('git pull')
    else:
        local('git clone git://github.com/altercation/mutt-colors-solarized.git mutt/solarized-colors')

    if os.path.isdir('mail/offlineimap'):
        with lcd('mail/offlineimap'):
            local('git pull')
    else:
        local('git clone git://github.com/nicolas33/offlineimap.git mail/offlineimap')

    print 'Finished cloning/upping repositories'

    with lcd('bin'):
        wget('http://betterthangrep.com/ack-standalone', 'ack')
        wget('http://stackp.online.fr/wp-content/uploads/droopy')
        wget('https://github.com/technomancy/leiningen/raw/stable/bin/lein')
        wget('http://releases.clojure-cake.org/cake')

    wget('https://bitbucket.org/sjl/t/raw/tip/t.py', os.path.expanduser('~/.t.py'))

    # Stuff that make command line more fun!
    with lcd('shell/custom-configs'):
        wget('https://github.com/sjl/z-zsh/raw/master/z.sh', 'sjl-z.sh')

    with lcd('shell/oh-my-zsh/plugins'):
        if os.path.isdir('zsh-syntax-highlighting'):
            with lcd('zsh-syntax-highlighting'):
                local('git pull')
        else:
            local('git clone git://github.com/nicoulaj/zsh-syntax-highlighting.git')

    # Download oh-my-zsh and set it up
    if os.path.isdir('shell/oh-my-zsh'):
        with lcd('shell/oh-my-zsh'):
            local('git pull')
    else:
        local('git clone git@github.com:sharat87/oh-my-zsh.git')

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

def wget(url, dst=None):
    if dst is None:
        dst = os.path.basename(url)

    local('wget --no-check-certificate -O "' + dst + '" "' + url + '"')
