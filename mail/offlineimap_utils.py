
import os
from ConfigParser import SafeConfigParser

creds = SafeConfigParser()
creds.readfp(open(os.path.expanduser('~/Dropbox/Private/creds.ini')))

def read_pass():
    return creds.get('cmail', 'password')

def read_user():
    return creds.get('cmail', 'username')

def read_host():
    return creds.get('cmail', 'imap-server')

def read_port():
    return creds.get('cmail', 'imap-port')

def read_gmail_user():
    return creds.get('cmail', 'gusername')

def read_gmail_pass():
    return creds.get('cmail', 'gpassword')
