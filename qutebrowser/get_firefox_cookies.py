import sqlite3
import os
from pathlib import Path
import shutil
import atexit

# Not complete yet. Work in progress.

FIREFOX_COOKIES_DB = next(Path("~/Library/Application Support/Firefox/Profiles").expanduser().glob("*.default-release")) / "cookies.sqlite"
QUTE_COOKIES_DB = Path("~/Library/Application Support/qutebrowser/webengine/Cookies").expanduser()

tmp_loc = "ff-cookies.sqlite3"
shutil.copy(FIREFOX_COOKIES_DB, tmp_loc)
@atexit.register
def clean():
    for path in Path.cwd().glob(tmp_loc + "*"):
        os.remove(path)

firefox_db = sqlite3.connect(tmp_loc)
c = firefox_db.cursor()
for row in c.execute("select name, value, host, path, expiry from moz_cookies limit 4"):
    print(repr(row))

qute_db = sqlite3.connect(QUTE_COOKIES_DB)
c = qute_db.cursor()
for row in c.execute("select name, value, host_key, path, expires_utc from cookies limit 4"):
    print(repr(row))

# Schema in Firefox cookies DB:
# CREATE TABLE moz_cookies (
#     id INTEGER PRIMARY KEY,
#     originAttributes TEXT NOT NULL DEFAULT '',
#     name TEXT,
#     value TEXT,
#     host TEXT,
#     path TEXT,
#     expiry INTEGER,
#     lastAccessed INTEGER,
#     creationTime INTEGER,
#     isSecure INTEGER,
#     isHttpOnly INTEGER,
#     inBrowserElement INTEGER DEFAULT 0,
#     sameSite INTEGER DEFAULT 0,
#     rawSameSite INTEGER DEFAULT 0,
#     schemeMap INTEGER DEFAULT 0,
#     CONSTRAINT moz_uniqueid UNIQUE (name, host, path, originAttributes)
# );

# Schema in Qute cookies DB:
# CREATE TABLE cookies(
#     creation_utc INTEGER NOT NULL,
#     host_key TEXT NOT NULL,
#     name TEXT NOT NULL,
#     value TEXT NOT NULL,
#     path TEXT NOT NULL,
#     expires_utc INTEGER NOT NULL,
#     is_secure INTEGER NOT NULL,
#     is_httponly INTEGER NOT NULL,
#     last_access_utc INTEGER NOT NULL,
#     has_expires INTEGER NOT NULL DEFAULT 1,
#     is_persistent INTEGER NOT NULL DEFAULT 1,
#     priority INTEGER NOT NULL DEFAULT 1,
#     encrypted_value BLOB DEFAULT '',
#     samesite INTEGER NOT NULL DEFAULT -1,
#     source_scheme INTEGER NOT NULL DEFAULT 0,
#     UNIQUE (host_key, name, path)
# );
