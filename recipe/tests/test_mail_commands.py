import imaplib
import poplib
import unittest
from unittest.mock import Mock


class MailCommandTests(unittest.TestCase):
    def test_pop3_controls(self):
        client = Mock(_debugging=0, encoding='ascii')
        for code in (*range(32), 127):
            with self.subTest(code=code):
                with self.assertRaises(ValueError):
                    poplib.POP3._putcmd(client, f'USER user{chr(code)}')
        client._putline.assert_not_called()
        poplib.POP3._putcmd(client, 'USER user')
        client._putline.assert_called_once_with(b'USER user')

    def test_imap_controls(self):
        client = Mock(state='NONAUTH', literal=None, untagged_responses={},
                      is_readonly=False, _encoding='ascii', debug=0)
        client._new_tag.return_value = b'T0'
        for char in '\0\r\n':
            for arg in (f'user{char}', f'user{char}'.encode('ascii')):
                with self.subTest(arg=arg):
                    with self.assertRaises(ValueError):
                        imaplib.IMAP4._command(client, 'LOGIN', arg, 'password')
        client.send.assert_not_called()
        imaplib.IMAP4._command(client, 'LOGIN', 'user', '"pass\tword"')
        client.send.assert_called_once_with(b'T0 LOGIN user "pass\tword"\r\n')


if __name__ == '__main__':
    unittest.main()
