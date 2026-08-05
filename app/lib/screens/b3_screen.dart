import 'package:flutter/material.dart';

import '../models/market_data.dart';
import '../services/b3_service.dart';
import '../services/watchlist_service.dart';

/// Full B3 stock list with live prices and weekly return, plus a
/// shortcut to add/remove each ticker from the watchlist.
class B3Screen extends StatefulWidget {
  const B3Screen({super.key});

  @override
  State<B3Screen> createState() => _B3ScreenState();
}

class _B3ScreenState extends State<B3Screen> {
  final _b3 = B3Service();
  final _watchlist = WatchlistService();
  Map<String, double> _prices = {};
  List<String> _watched = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _watched = await _watchlist.loadStocks();
    _prices = await _b3.getAllPricesBrl(b3Stocks.keys.toList());
    if (!mounted) return;
    setState(() => _loading = false);
  }

  Future<void> _toggle(String ticker) async {
    if (_watched.contains(ticker)) {
      _watched = await _watchlist.removeStock(ticker);
    } else {
      _watched = await _watchlist.addStock(ticker);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        children: [
          for (final entry in b3Stocks.entries)
            ListTile(
              title: Text('${entry.value.name} (${entry.key})'),
              subtitle: Text(
                'R\$ ${(_prices[entry.key] ?? entry.value.priceBrl).toStringAsFixed(2)} · '
                'Rendimento semanal: ${entry.value.weeklyReturn.toStringAsFixed(2)}%',
              ),
              trailing: IconButton(
                icon: Icon(
                  _watched.contains(entry.key) ? Icons.star : Icons.star_border,
                  color: _watched.contains(entry.key) ? Colors.amber : null,
                ),
                tooltip: _watched.contains(entry.key) ? 'Remover da watchlist' : 'Adicionar à watchlist',
                onPressed: () => _toggle(entry.key),
              ),
            ),
        ],
      ),
    );
  }
}
