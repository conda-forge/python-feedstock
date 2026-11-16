import base64
import unittest
import warnings


class Base64WarningTests(unittest.TestCase):
    def test_alternative_alphabet_warnings(self):
        for data in (b'++++', b'////', '++++', '////'):
            expected = base64.b64decode(data)
            for validate in (False, True):
                with self.subTest(data=data, validate=validate):
                    warning = DeprecationWarning if validate else FutureWarning
                    with self.assertWarns(warning):
                        result = base64.b64decode(data, b'-_', validate=validate)
                    self.assertEqual(result, expected)
            with self.assertWarns(FutureWarning):
                self.assertEqual(base64.urlsafe_b64decode(data), expected)

    def test_valid_alphabets_do_not_warn(self):
        with warnings.catch_warnings():
            warnings.simplefilter('error')
            self.assertEqual(base64.b64decode(b'++++', b'+_'), b'\xfb\xef\xbe')
            self.assertEqual(base64.urlsafe_b64decode(b'____'), b'\xff\xff\xff')


if __name__ == '__main__':
    unittest.main()
