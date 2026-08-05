import 'package:shared_preferences/shared_preferences.dart';

import '../models/market_data.dart';

/// Persists the user's watchlist (currencies + B3 tickers) in the
/// browser's localStorage. No account/login is involved — everything is
/// scoped to the local browser, same spirit as the cookie-based storage
/// originally requested.
class WatchlistService {
  static const _currenciesKey = 'watchlist_currencies';
  static const _stocksKey = 'watchlist_stocks';

  static const defaultCurrencies = ['USD', 'BTC', 'ETH', 'BNB', 'SUI', 'PAXG'];
  static const defaultStocks = ['PETR4', 'VALE3', 'ITUB4', 'BBAS3', 'WEGE3'];

  Future<List<String>> loadCurrencies() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_currenciesKey) ?? List.of(defaultCurrencies);
  }

  Future<List<String>> loadStocks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_stocksKey) ?? List.of(defaultStocks);
  }

  Future<void> saveCurrencies(List<String> codes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_currenciesKey, codes);
  }

  Future<void> saveStocks(List<String> tickers) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_stocksKey, tickers);
  }

  Future<List<String>> addCurrency(String code) async {
    final list = await loadCurrencies();
    final normalized = code.trim().toUpperCase();
    if (normalized.isEmpty || list.contains(normalized)) return list;
    list.add(normalized);
    await saveCurrencies(list);
    return list;
  }

  Future<List<String>> removeCurrency(String code) async {
    final list = await loadCurrencies();
    list.remove(code);
    await saveCurrencies(list);
    return list;
  }

  Future<List<String>> addStock(String ticker) async {
    final list = await loadStocks();
    final normalized = ticker.trim().toUpperCase();
    if (normalized.isEmpty || list.contains(normalized)) return list;
    list.add(normalized);
    await saveStocks(list);
    return list;
  }

  Future<List<String>> removeStock(String ticker) async {
    final list = await loadStocks();
    list.remove(ticker);
    await saveStocks(list);
    return list;
  }

  /// Human-readable label for a currency code, falling back to the code
  /// itself for user-added currencies not in the known list.
  String currencyLabel(String code) => currencyNames[code] ?? code;
}
