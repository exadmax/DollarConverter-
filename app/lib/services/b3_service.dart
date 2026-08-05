import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/market_data.dart';

/// Fetches B3 stock, US stock and market index quotes from brapi.dev,
/// with offline fallback for known tickers. The returned price is in
/// the ticker's native currency (BRL for B3/indices, USD for US
/// stocks and the S&P 500) — brapi.dev doesn't convert.
class B3Service {
  static const _baseUrl = 'https://brapi.dev/api/quote';

  /// Free-tier brapi.dev token, required to query market indices
  /// (^BVSP, IFIX, ^GSPC, ...) — plain stock tickers work without it.
  /// This app has no backend, and brapi's free-tier token is meant to
  /// be used client-side (it's a public, rate-limited identifier, not
  /// a secret), so it's safe to ship in this open-source client.
  static const _token = 'pUo1aJbbhMjw5idkFbm3pB';

  /// Fetch the live BRL price for [ticker] (a B3 ticker or an index
  /// like `^BVSP`, `IFIX`, `^GSPC`). Throws if the request fails or the
  /// ticker is unknown to the API.
  Future<double> fetchPriceBrl(String ticker) async {
    final uri = Uri.parse(
      '$_baseUrl/$ticker?range=1d&interval=1d&fundamental=false&dividends=false&token=$_token',
    );
    late final http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 10));
    } catch (_) {
      throw Exception('API de ações indisponível');
    }
    if (response.statusCode != 200) {
      throw Exception('API de ações indisponível');
    }
    final Map<String, dynamic> data = jsonDecode(response.body);
    final results = (data['results'] ?? data['stocks']) as List<dynamic>?;
    if (results == null || results.isEmpty) {
      throw Exception('Ticker inválido');
    }
    final price = results.first['regularMarketPrice'];
    if (price == null) {
      throw Exception('Preço não disponível');
    }
    return (price as num).toDouble();
  }

  /// Latest price for a known B3/US [ticker] or market index, falling
  /// back to the offline table on failure. For unknown tickers
  /// (user-added), the live fetch is required and failures propagate.
  Future<double> getPriceBrl(String ticker) async {
    try {
      return await fetchPriceBrl(ticker);
    } catch (_) {
      final info = b3Stocks[ticker] ?? spStocks[ticker];
      if (info != null) return info.price;
      final indexFallback = indexFallbackPoints[ticker];
      if (indexFallback != null) return indexFallback;
      rethrow;
    }
  }

  Future<Map<String, double>> getAllPricesBrl(List<String> tickers) async {
    final result = <String, double>{};
    for (final t in tickers) {
      try {
        result[t] = await getPriceBrl(t);
      } catch (_) {
        // Skip tickers that cannot be priced at all (unknown + offline).
      }
    }
    return result;
  }
}
