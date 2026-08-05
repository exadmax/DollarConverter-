import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/market_data.dart';

/// Thrown when the quote API cannot be reached (network/HTTP failure).
class QuoteApiException implements Exception {
  final String message;
  QuoteApiException(this.message);
  @override
  String toString() => message;
}

/// Thrown when a currency pair is not recognized by the API.
class InvalidPairException implements Exception {
  final String message;
  InvalidPairException(this.message);
  @override
  String toString() => message;
}

/// Fetches fiat/crypto exchange rates from AwesomeAPI and performs
/// conversions, mirroring the logic that used to live in core.py.
class ExchangeService {
  static const _baseUrl = 'https://economia.awesomeapi.com.br/json/last';

  Future<double> getExchangeRate(String origem, String destino) async {
    final uri = Uri.parse('$_baseUrl/$origem-$destino');
    late final http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 10));
    } catch (e) {
      throw QuoteApiException('API de cotações indisponível');
    }
    if (response.statusCode != 200) {
      throw QuoteApiException('API de cotações indisponível');
    }
    final Map<String, dynamic> data = jsonDecode(response.body);
    final key = '$origem$destino';
    if (!data.containsKey(key)) {
      throw InvalidPairException('Par de moedas inválido');
    }
    return double.parse(data[key]['bid'] as String);
  }

  /// Convert [value] from [origem] to [destino]. When converting to BRL
  /// and a direct pair is unavailable, falls back through USD.
  Future<double> convert(double value, String origem, String destino) async {
    double rate;
    try {
      rate = await getExchangeRate(origem, destino);
    } on InvalidPairException {
      if (destino == 'BRL' && origem != 'BRL') {
        final usdRate = await getExchangeRate(origem, 'USD');
        final brlRate = await getExchangeRate('USD', 'BRL');
        rate = usdRate * brlRate;
      } else {
        rethrow;
      }
    }
    return value * rate;
  }

  /// Latest BRL price of [code]. Falls back to the last known offline
  /// value if the API is unreachable or the pair is invalid.
  Future<double> getCurrencyPriceBrl(String code) async {
    if (code == 'BRL') return 1.0;
    try {
      return await convert(1.0, code, 'BRL');
    } catch (_) {
      final hist = currencyHistoryBrl[code];
      if (hist == null || hist.isEmpty) rethrow;
      return hist.last;
    }
  }

  Future<Map<String, double>> getAllCurrencyPricesBrl(List<String> codes) async {
    final result = <String, double>{};
    for (final code in codes) {
      result[code] = await getCurrencyPriceBrl(code);
    }
    return result;
  }
}
