import 'dart:async';

import 'package:flutter/material.dart';

import '../models/market_data.dart';
import '../services/b3_service.dart';
import '../services/exchange_service.dart';
import '../services/watchlist_service.dart';
import '../widgets/price_tile.dart';

/// Main monitoring dashboard: shows the user's watchlist of currencies
/// and B3 tickers (including the Ibovespa index), refreshing prices
/// automatically every 5 minutes, mirroring the old "monitor" mode.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _watchlist = WatchlistService();
  final _exchange = ExchangeService();
  final _b3 = B3Service();

  List<String> _currencies = [];
  List<String> _stocks = [];
  Map<String, double> _currencyPrices = {};
  Map<String, double> _stockPrices = {};
  bool _loading = true;
  DateTime? _lastUpdated;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _bootstrap();
    _timer = Timer.periodic(const Duration(minutes: 5), (_) => _refreshPrices());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    _currencies = await _watchlist.loadCurrencies();
    _stocks = await _watchlist.loadStocks();
    await _refreshPrices();
  }

  Future<void> _refreshPrices() async {
    setState(() => _loading = true);
    final currencyPrices = await _exchange.getAllCurrencyPricesBrl(_currencies);
    final tickers = [ibovespaTicker, ..._stocks];
    final stockPrices = await _b3.getAllPricesBrl(tickers);
    if (!mounted) return;
    setState(() {
      _currencyPrices = currencyPrices;
      _stockPrices = stockPrices;
      _loading = false;
      _lastUpdated = DateTime.now();
    });
  }

  Future<void> _addCurrency() async {
    final code = await _promptForCode(
      title: 'Adicionar moeda',
      hint: 'Código (ex: LTC, XRP, DOGE)',
    );
    if (code == null || code.isEmpty) return;
    setState(() => _loading = true);
    try {
      // Validate against the live API before saving.
      await _exchange.getExchangeRate(code.toUpperCase(), 'BRL');
      _currencies = await _watchlist.addCurrency(code);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Código de moeda inválido ou indisponível.')),
        );
      }
    }
    await _refreshPrices();
  }

  Future<void> _addStock() async {
    final ticker = await _promptForCode(
      title: 'Adicionar ação/FII da B3',
      hint: 'Ticker (ex: TAEE11)',
    );
    if (ticker == null || ticker.isEmpty) return;
    setState(() => _loading = true);
    try {
      await _b3.fetchPriceBrl(ticker.toUpperCase());
      _stocks = await _watchlist.addStock(ticker);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ticker inválido ou indisponível.')),
        );
      }
    }
    await _refreshPrices();
  }

  Future<String?> _promptForCode({required String title, required String hint}) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(hintText: hint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  Future<void> _removeCurrency(String code) async {
    _currencies = await _watchlist.removeCurrency(code);
    setState(() => _currencyPrices.remove(code));
  }

  Future<void> _removeStock(String ticker) async {
    _stocks = await _watchlist.removeStock(ticker);
    setState(() => _stockPrices.remove(ticker));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPrices,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _lastUpdated == null
                      ? 'Atualizando...'
                      : 'Atualizado às ${_lastUpdated!.hour.toString().padLeft(2, '0')}:${_lastUpdated!.minute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (_loading) const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Moedas e Criptomoedas', style: Theme.of(context).textTheme.titleMedium),
                IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: _addCurrency),
              ],
            ),
          ),
          for (final code in _currencies)
            PriceTile(
              code: code,
              label: _watchlist.currencyLabel(code),
              price: _currencyPrices[code],
              loading: _loading && _currencyPrices[code] == null,
              onRemove: () => _removeCurrency(code),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ibovespa e Ações B3', style: Theme.of(context).textTheme.titleMedium),
                IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: _addStock),
              ],
            ),
          ),
          PriceTile(
            code: 'IBOV',
            label: 'Índice Ibovespa',
            price: _stockPrices[ibovespaTicker],
            loading: _loading && _stockPrices[ibovespaTicker] == null,
          ),
          for (final ticker in _stocks)
            PriceTile(
              code: ticker,
              label: b3Stocks[ticker]?.name ?? ticker,
              price: _stockPrices[ticker],
              loading: _loading && _stockPrices[ticker] == null,
              onRemove: () => _removeStock(ticker),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
