#!/usr/bin/python
#-*- coding:utf-8 -*-

import sys, os, ldap
from ConfigParser import SafeConfigParser

if len(sys.argv) < 2:
    raise SystemExit('Please give a search string')

search = sys.argv[1]

creds = SafeConfigParser()
creds.readfp(open(os.path.expanduser('~/Dropbox/Private/creds.ini')))
server = creds.get('cmail', 'ldap-server')
basedn = creds.get('cmail', 'base-dn')
password = creds.get('cmail', 'password')

base = 'o=calypso.com,ou=domains'
scope = ldap.SCOPE_SUBTREE
sfilter = '(|(displayName=' + search + '*)(sn=' + search + '*))'

attrs = ["display-name", "mail"]
# attrs = None # Get all attributes

l = ldap.initialize(server)
l.set_option(ldap.OPT_REFERRALS, 0)
l.protocol_version = 3
l.simple_bind_s(basedn, password)

r = l.search(base, scope, sfilter, attrs)
code, data = l.result(r, 60)

if data:
    print len(data), 'results found'
else:
    print 'No results found'

for name, attrs in data:
    print attrs['mail'][0] + '\t' + attrs['display-name'][0] + '\t' + '.'
