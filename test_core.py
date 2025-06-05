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

    def test_get_b3_stock_info(self):
        info = core.get_b3_stock_info('PETR4')
        self.assertIn('price_brl', info)
        with self.assertRaises(ValueError):
            core.get_b3_stock_info('XXXX')

    def test_currency_monthly_appreciation(self):
        vals = core.get_currency_monthly_appreciation('USD')
        self.assertEqual(len(vals), len(core.CURRENCY_HISTORY_BRL['USD']) - 1)
        with self.assertRaises(ValueError):
            core.get_currency_monthly_appreciation('XYZ')

    def test_stock_monthly_appreciation(self):
        vals = core.get_stock_monthly_appreciation('PETR4')
        self.assertEqual(len(vals), len(core.B3_STOCKS['PETR4']['monthly']) - 1)
        with self.assertRaises(ValueError):
            core.get_stock_monthly_appreciation('XXXX')

if __name__ == '__main__':
    unittest.main()

