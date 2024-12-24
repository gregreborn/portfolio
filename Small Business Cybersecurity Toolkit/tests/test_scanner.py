import unittest
from vulnerability_scanner.validators import validate_ip, validate_hostname

class TestValidators(unittest.TestCase):
    def test_validate_ip(self):
        self.assertTrue(validate_ip("192.168.1.1"))
        self.assertFalse(validate_ip("999.999.999.999"))

    def test_validate_hostname(self):
        self.assertTrue(validate_hostname("example.com"))
        self.assertFalse(validate_hostname("invalid_hostname"))
