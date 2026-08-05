import 'package:shared_preferences/shared_preferences.dart';

import '../models/market_data.dart';

/// Persists the user's watchlist (currencies, B3 tickers and US
/// stocks) in the browser's localStorage. No account/login is
/// involved — everything is scoped to the local browser, same spirit
/// as the cookie-based storage originally requested.
class WatchlistService {
  static const _currenciesKey = 'watchlist_currencies';
  static const _stocksKey = 'watchlist_stocks';
  static const _usStocksKey = 'watchlist_us_stocks';

  static const defaultCurrencies = ['USD', 'BTC', 'ETH', 'BNB', 'SUI', 'PAXG'];
  static const defaultStocks = ['PETR4', 'VALE3', 'ITUB4', 'BBAS3', 'WEGE3'];
  static const defaultUsStocks = ['AAPL', 'MSFT', 'GOOGL', 'AMZN', 'NVDA'];

  Future<List<String>> _load(String key, List<String> fallback) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? List.of(fallback);
  }

  Future<void> _save(String key, List<String> values) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, values);
  }

  Future<List<String>> _add(String key, List<String> fallback, String value) async {
    final list = await _load(key, fallback);
    final normalized = value.trim().toUpperCase();
    if (normalized.isEmpty || list.contains(normalized)) return list;
    list.add(normalized);
    await _save(key, list);
    return list;
  }

  Future<List<String>> _remove(String key, List<String> fallback, String value) async {
    final list = await _load(key, fallback);
    list.remove(value);
    await _save(key, list);
    return list;
  }

  Future<List<String>> loadCurrencies() => _load(_currenciesKey, defaultCurrencies);
  Future<void> saveCurrencies(List<String> codes) => _save(_currenciesKey, codes);
  Future<List<String>> addCurrency(String code) => _add(_currenciesKey, defaultCurrencies, code);
  Future<List<String>> removeCurrency(String code) => _remove(_currenciesKey, defaultCurrencies, code);

  Future<List<String>> loadStocks() => _load(_stocksKey, defaultStocks);
  Future<void> saveStocks(List<String> tickers) => _save(_stocksKey, tickers);
  Future<List<String>> addStock(String ticker) => _add(_stocksKey, defaultStocks, ticker);
  Future<List<String>> removeStock(String ticker) => _remove(_stocksKey, defaultStocks, ticker);

  Future<List<String>> loadUsStocks() => _load(_usStocksKey, defaultUsStocks);
  Future<void> saveUsStocks(List<String> tickers) => _save(_usStocksKey, tickers);
  Future<List<String>> addUsStock(String ticker) => _add(_usStocksKey, defaultUsStocks, ticker);
  Future<List<String>> removeUsStock(String ticker) => _remove(_usStocksKey, defaultUsStocks, ticker);

  /// Human-readable label for a currency code, falling back to the code
  /// itself for user-added currencies not in the known list.
  String currencyLabel(String code) => currencyNames[code] ?? code;
}
