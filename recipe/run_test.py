import os
import platform
import sys
import subprocess

armv6l = bool(platform.machine() == 'armv6l')
armv7l = bool(platform.machine() == 'armv7l')
ppc64le = bool(platform.machine() == 'ppc64le')
if sys.platform == 'darwin':
    osx105 = b'10.5.' in subprocess.check_output('sw_vers')
else:
    osx105 = False

print('sys.version:', sys.version)
print('sys.platform:', sys.platform)
print('tuple.__itemsize__:', tuple.__itemsize__)
if sys.platform == 'win32':
    assert 'MSC v.19' in sys.version
print('sys.maxunicode:', sys.maxunicode)
print('platform.architecture:', platform.architecture())
print('platform.python_version:', platform.python_version())

import _bisect
import _codecs_cn
import _codecs_hk
import _codecs_iso2022
import _codecs_jp
import _codecs_kr
import _codecs_tw
import _collections
import _csv
import _ctypes
import _ctypes_test
import _decimal
import _elementtree
import _functools
import _hashlib
import _heapq
import _io
import _json
import _locale
import _lsprof
import _lzma
import _multibytecodec
import _multiprocessing
import _random
import _socket
import _sqlite3
import _ssl
import _struct
import _testcapi
import array
import audioop
import binascii
import bz2
import cmath
import datetime
import itertools
import lzma
import math
import mmap
import operator
import pyexpat
import select
import time
import test
import test.support
import unicodedata
import zlib
from os import urandom
import os

t = 100 * b'Foo '
assert lzma.decompress(lzma.compress(t)) == t

if sys.platform != 'win32':
    if not (ppc64le or armv7l):
        import _curses
        import _curses_panel
    import crypt
    import fcntl
    import grp
    import nis
    import readline
    import resource
    import syslog
    import termios


if not (armv6l or armv7l or ppc64le or osx105):
    import tkinter
    import turtle
    import _tkinter
    print('TK_VERSION: %s' % _tkinter.TK_VERSION)
    print('TCL_VERSION: %s' % _tkinter.TCL_VERSION)
    # conda-build >= 26.9 no longer exports variant keys (e.g. "tk") into the
    # test environment when tests run inline during `conda build`; fall back to
    # the version pinned in meta.yaml.
    TCLTK_VER = os.getenv("tk") or "8.6"
    assert _tkinter.TK_VERSION == _tkinter.TCL_VERSION == TCLTK_VER

# CVE-2015-20107 (mailcap shell injection): findmatch() must refuse filenames
# containing shell metacharacters, and subst() must refuse unsafe MIME types and
# parameters. The fix landed upstream in 3.9.16, so the 3.9.25 recipe needs no
# backport patch - this asserts the shipped interpreter really has it.
import mailcap
import warnings

CAPS = {'text/plain': [{'view': 'cat %s'}]}

with warnings.catch_warnings(record=True) as caught:
    warnings.simplefilter('always')
    cmd, _ = mailcap.findmatch(CAPS, 'text/plain', filename='unsafe; touch pwned')
assert cmd is None, 'mailcap accepted an unsafe filename: %r' % (cmd,)
assert any(issubclass(w.category, mailcap.UnsafeMailcapInput) for w in caught), caught
assert not os.path.exists('pwned')

# Safe input must still resolve to exactly the same command as before.
cmd, _ = mailcap.findmatch(CAPS, 'text/plain', filename='safe-name.txt')
assert cmd == 'cat safe-name.txt', cmd

import ssl
print('OPENSSL_VERSION:', ssl.OPENSSL_VERSION)
# Same caveat as above for "openssl".
CONDA_OPENSSL_VERSION = os.getenv("openssl") or "3"
assert CONDA_OPENSSL_VERSION in ssl.OPENSSL_VERSION

# See https://github.com/conda-forge/python-feedstock/issues/718 for context:
assert sys.hash_info.algorithm.startswith("siphash")

# ---------------------------------------------------------------------------
# Security backports from the RHEL 9 python3.9 package (see the patch list in
# meta.yaml). Each check fails on an unpatched 3.9.25 interpreter, so it keeps
# the backport from silently disappearing.
# ---------------------------------------------------------------------------

# CVE-2025-12084 (minidom): the quadratic _in_document() walk is gone; nodes
# track ownerDocument instead.
import xml.dom.minidom as minidom
assert not hasattr(minidom, '_in_document'), 'minidom still has the quadratic _in_document() walk'
_e = minidom.Element('test')
_a = minidom.Attr('id')
_a.value = 'test-id'
_e.setAttributeNode(_a)
assert _e.getAttribute('id') == 'test-id'

# CVE-2026-0865 (wsgiref.headers): C0 control characters are rejected.
from wsgiref.headers import Headers
for _bad in ('a\x00b', 'a\rb', 'a\x7fb'):
    try:
        Headers([('X-Test', _bad)])
    except ValueError:
        pass
    else:
        raise AssertionError('wsgiref accepted control character: %r' % _bad)

# CVE-2025-15367 (poplib): control characters are rejected in commands.
import poplib
_p = poplib.POP3.__new__(poplib.POP3)
_p.encoding = 'utf-8'
_p._debugging = 0
_p._putline = lambda line: None
try:
    _p._putcmd('NOOP\r\nRETR 1')
except ValueError:
    pass
else:
    raise AssertionError('poplib accepted a control character in a command')

# CVE-2025-15366 (imaplib): control characters are rejected in commands.
import imaplib
_i = imaplib.IMAP4.__new__(imaplib.IMAP4)
_i._encoding = 'ascii'
_i.state = 'NONAUTH'
_i.untagged_responses = {}
_i.is_readonly = False
_i.literal = None
_i.debug = 0
_i._new_tag = lambda: b'A1'
_i.send = lambda data: None
_i._get_response = lambda: (b'OK', [b'NOOP completed'])
try:
    _i._command('NOOP', 'x\r\n')
except ValueError:
    pass
else:
    raise AssertionError('imaplib accepted a control character in a command')

# CVE-2026-1299 (email): BytesGenerator rejects headers that fold to a newline.
import io
import email.errors
import email.policy
from email.generator import BytesGenerator
from email.message import Message


class _BadPolicy(email.policy.EmailPolicy):
    def fold_binary(self, name, value):
        return b'Subject: x\r\nInjected: y\r\n\r\n'


_msg = Message(policy=_BadPolicy())
_msg['Subject'] = 'x'
try:
    BytesGenerator(io.BytesIO(), policy=_BadPolicy()).flatten(_msg)
except email.errors.HeaderWriteError:
    pass
else:
    raise AssertionError('BytesGenerator accepted an injected header')

# CVE-2026-4519 (webbrowser): dash-prefixed URLs are rejected.
import webbrowser
try:
    webbrowser.GenericBrowser('definitely-not-a-browser').open('--help')
except ValueError:
    pass
else:
    raise AssertionError('webbrowser accepted a dash-prefixed URL')

# CVE-2026-15308 (html.parser): incremental feeds still parse correctly.
from html.parser import HTMLParser


class _HTML(HTMLParser):
    def __init__(self):
        super().__init__()
        self.seen = []

    def handle_starttag(self, tag, attrs):
        self.seen.append(tag)


_h = _HTML()
for _chunk in ('<div', ' class="x"', '>text</div'):
    _h.feed(_chunk)
_h.feed('>')
_h.close()
assert _h.seen == ['div'], _h.seen

# CVE-2026-11940 (tarfile): a hardlink may not be extracted through a symlink
# that the data filter accepted as a copy fallback.
import tarfile
import tempfile
_buf = io.BytesIO()
with tarfile.open(fileobj=_buf, mode='w') as _tf:
    _s = tarfile.TarInfo('a/b/s')
    _s.type = tarfile.SYMTYPE
    _s.linkname = '../escape'
    _tf.addfile(_s)
    _l = tarfile.TarInfo('s')
    _l.type = tarfile.LNKTYPE
    _l.linkname = 'a/b/s'
    _tf.addfile(_l)
_buf.seek(0)
with tempfile.TemporaryDirectory() as _td:
    with tarfile.open(fileobj=_buf) as _tf:
        try:
            _tf.extractall(path=_td, filter='data')
        except tarfile.FilterError:
            pass
        else:
            raise AssertionError('tarfile extracted a hardlink through an escaping symlink')
