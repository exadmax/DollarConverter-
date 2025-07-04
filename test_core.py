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

    def test_convert_to_brl_via_usd(self):
        seq = [
            ValueError('Par de moedas inválido'),
            300.0,  # BNB->USD
            5.0     # USD->BRL
        ]

        def side_effect(origem, destino):
            res = seq.pop(0)
            if isinstance(res, Exception):
                raise res
            return res

        with patch('core.get_exchange_rate', side_effect=side_effect):
            result = core.convert(1, 'BNB', 'BRL')
            self.assertEqual(result, 1500.0)

    def test_get_currency_price_brl_fallback(self):
        seq = [
            ValueError('Par de moedas inválido'),
            200.0,  # ETH->USD
            5.0     # USD->BRL
        ]

        def side_effect(origem, destino):
            res = seq.pop(0)
            if isinstance(res, Exception):
                raise res
            return res

        with patch('core.get_exchange_rate', side_effect=side_effect):
            price = core.get_currency_price_brl('ETH')
            self.assertEqual(price, 1000.0)

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

    @patch('core.requests.get', side_effect=core.requests.RequestException)
    def test_get_exchange_rate_api_down(self, mock_get):
        with self.assertRaises(ConnectionError):
            core.get_exchange_rate('USD', 'BRL')

    @patch('core.requests.get')
    def test_fetch_b3_stock_price_success(self, mock_get):
        mock_resp = mock_get.return_value
        mock_resp.raise_for_status.return_value = None
        mock_resp.json.return_value = {"results": [{"regularMarketPrice": 99.0}]}
        price = core.fetch_b3_stock_price_brl('PETR4')
        self.assertEqual(price, 99.0)

    @patch('core.requests.get', side_effect=core.requests.RequestException)
    def test_fetch_b3_stock_price_api_down(self, mock_get):
        with self.assertRaises(ConnectionError):
            core.fetch_b3_stock_price_brl('PETR4')

    @patch('core.requests.get')
    def test_fetch_b3_stock_price_invalid(self, mock_get):
        mock_resp = mock_get.return_value
        mock_resp.raise_for_status.return_value = None
        mock_resp.json.return_value = {}
        with self.assertRaises(ValueError):
            core.fetch_b3_stock_price_brl('XXXX')

    @patch('core.fetch_b3_stock_price_brl', side_effect=ConnectionError)
    def test_get_b3_stock_price_brl_fallback(self, mock_fetch):
        price = core.get_b3_stock_price_brl('PETR4')
        self.assertEqual(price, core.B3_STOCKS['PETR4']['price_brl'])

if __name__ == '__main__':
    unittest.main()

