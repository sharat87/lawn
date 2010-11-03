#!/usr/bin/python
#-*- coding:utf-8 -*-

'''
Send notification bubbles through the `notify-send` shell command on certain
events like update, commit etc.
'''

import subprocess as sp

EVENTS = 'update commit outgoing incoming'.split()

def mkhook(action):
    def hookfn(ui, repo, **kwargs):
        notify(action.title() + ' done')
    return hookfn

def reposetup(ui, repo):
    for e in EVENTS:
        ui.setconfig('hooks', e + '.notify', mkhook(e))

def notify(message, title='Mercurial'):
    sp.call('notify-send "' + title + '" "' + message + '"', shell=True)
