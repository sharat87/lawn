#!/usr/bin/python
#-*- coding:utf-8 -*-

from datetime import datetime
import MySQLdb as dbh
import pysvn
import re
import sys, os

def gen_hook():
    """Generate hook script for your project"""

    f = open('delta_hook.py', 'w')
    f.write(HOOK_PY)
    f.close()

def main():

    sys.path.append(os.path.abspath('.'))

    import delta_hook as hook

    db_creds = hook.creds

    wcopy = '.'

    if hasattr(hook, 'before_db_dump'):
        hook.before_db_dump()

    db_loc = os.path.join(wcopy, 'db.sql')

    has_dump = os.path.exists(db_loc)

    mysqldump(db_creds, db_loc)

    client = pysvn.Client()

    if not has_dump:
        client.add(db_loc)

    msg = raw_input('Commit message: ')

    if msg:
        client.checkin(wcopy, msg)
    else:
        print 'Commit cancelled'
        raise SystemExit(0)

class DBTable(object):
    def __init__(self, row):
        self.name, self.type = row
    
    def __cmp__(self, other):
        return (1 if self.type == 'VIEW' else -1)
    
    def __str__(self):
        return '{type} {name}'.format(type=self.type, name=self.name)

def tables(con):
    cur = con.cursor()

    cur.execute('SHOW FULL TABLES')

    return list(DBTable(a) for a in cur.fetchall())

def sanitize(row):
    srow = '('
    for c in row:
        if c is None:
            srow += 'NULL'
        elif type(c) in (int, long, float):
            srow += str(c)
        elif type(c) in (str, datetime):
            srow += "'" + str(c) + "'"
        else:
            print 'unknown type', c, type(c)
            srow += repr(c)
        srow += ', '
    if row:
        srow = srow[:-2]
    srow += ')'
    return srow

def mysqldump(conf, filename):

    sql = open(filename, 'w')

    con = dbh.connect(**conf)

    cur = con.cursor()

    sql.write(HEAD_TEXT.format(dbname=conf['db']))

    for table in sorted(tables(con)):
        print 'Processing {table}...'.format(table=str(table)),
        if table.type == 'BASE TABLE':
            cur.execute('SHOW CREATE TABLE ' + table.name)
            s = cur.fetchone()[1]

            sql.write('DROP TABLE IF EXISTS `' + table.name + '`;\n')
            sql.write(s + ';\n\n')

            cur.execute('SELECT * FROM ' + table.name)
            data = list(cur.fetchall())

            if data:
                sql.write('INSERT INTO `' + table.name + '` VALUES\n')

                sql.write('\t' + ',\n\t'.join(sanitize(row) for row in data) + ';\n\n')

        elif table.type == 'VIEW':
            cur.execute('SHOW CREATE TABLE ' + table.name)
            s = cur.fetchone()[1]
            s = re.sub('DEFINER=`.*?`@`.*?` ', '', s)
            sql.write('DROP TABLE IF EXISTS `' + table.name + '`;\n')
            sql.write('DROP VIEW IF EXISTS `' + table.name + '`;\n')
            sql.write(s + ';\n\n')

        print 'done'

    sql.write('SET FOREIGN_KEY_CHECKS = 1;\nCOMMIT;\n\n')

    cur.close()
    con.close()

HEAD_TEXT = '''
--
-- Setup environment
--

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;

--
-- Create schema proto_change_management
--

CREATE DATABASE IF NOT EXISTS {dbname};
USE {dbname};

'''

HOOK_PY = '''#!/usr/bin/python
#-*- coding:utf-8 -*-

creds = {
    'host': 'localhost',
    'user': 'USERNAME',
    'passwd': 'PASSWORD',
    'db': 'DATABASE'
}

'''

if __name__ == '__main__':
    if 'new' in sys.argv:
        gen_hook()
    else:
        main()

