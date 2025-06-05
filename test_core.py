import unittest
from unittest.mock import patch

import core

class TestCore(unittest.TestCase):
    def test_investment_for_weekly_profit(self):
        self.assertAlmostEqual(core.investment_for_weekly_profit(300, 3), 10000)
        with self.assertRaises(ValueError):
            core.investment_for_weekly_profit(100, 0)

    @patch('core.get_exchange_rate', return_value=5.0)
    def test_convert_with_mocked_rate(self, mock_rate):
        self.assertEqual(core.convert(2, 'USD', 'BRL'), 10.0)

if __name__ == '__main__':
    unittest.main()

