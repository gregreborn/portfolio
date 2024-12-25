import unittest
from vulnerability_scanner.validators import validate_ip, validate_hostname, resolve_hostname

class TestValidators(unittest.TestCase):

    def validate_ip(ip):
        """Validate the given IP address format."""
        ip_regex = r'^(\d{1,3}\.){3}\d{1,3}$'
        if not re.match(ip_regex, ip):
            return False
        parts = ip.split('.')
        return all(0 <= int(part) <= 255 for part in parts)

    def test_validate_hostname(self):
        self.assertTrue(validate_hostname("example.com"))
        self.assertTrue(validate_hostname("subdomain.example.com"))
        self.assertFalse(validate_hostname("invalid_hostname"))

    def test_resolve_hostname(self):
        ip = resolve_hostname("google.com")
        self.assertIsNotNone(ip)
        self.assertRegex(ip, r'^(\d{1,3}\.){3}\d{1,3}$')  # Check if it's a valid IP format


if __name__ == "__main__":
    unittest.main()
