#!/usr/bin/python
#-*- coding:utf-8 -*-

import sys, os, ldap
from ConfigParser import SafeConfigParser

creds = SafeConfigParser()
creds.readfp(open(os.path.expanduser('~/Dropbox/Private/creds.ini')))
server = creds.get('cmail', 'ldap-server')
basedn = creds.get('cmail', 'base-dn')
password = creds.get('cmail', 'password')

base = 'o=calypso.com,ou=domains'
scope = ldap.SCOPE_SUBTREE
sfilter = '(|(displayName=*))'

attrs = ["display-name", "mail"]
# attrs = None # Get all attributes

l = ldap.initialize(server)
l.set_option(ldap.OPT_REFERRALS, 0)
l.protocol_version = 3
l.simple_bind_s(basedn, password)

r = l.search(base, scope, sfilter, attrs)
code, data = l.result(r, 60)

alias_filename = os.path.expanduser('~/.mutt/ldap-aliases.mutt')
alias_line = 'alias {key} {display_name} <{address}>'
with open(alias_filename, 'w') as afile:
    if not data:
        afile.write('# No addresses found to add')
    else:
        for name, attrs in data:
            if 'mail' in attrs:
                address = attrs['mail'][0]
                afile.write(alias_line.format(
                                key=address.split('@')[0],
                                display_name=attrs['display-name'][0],
                                address=address))
                afile.write('\n')
