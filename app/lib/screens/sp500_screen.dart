import 'package:flutter/material.dart';

import '../models/market_data.dart';
import '../services/b3_service.dart';
import '../services/watchlist_service.dart';

/// S&P 500 blue-chip US stock list with live prices (in USD) and
/// weekly return, plus a shortcut to add/remove each ticker from the
/// user's US stocks watchlist. Mirrors [B3Screen] for the American
/// market.
class SP500Screen extends StatefulWidget {
  const SP500Screen({super.key});

  @override
  State<SP500Screen> createState() => _SP500ScreenState();
}

class _SP500ScreenState extends State<SP500Screen> {
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
    _watched = await _watchlist.loadUsStocks();
    _prices = await _b3.getAllPricesBrl(spStocks.keys.toList());
    if (!mounted) return;
    setState(() => _loading = false);
  }

  Future<void> _toggle(String ticker) async {
    if (_watched.contains(ticker)) {
      _watched = await _watchlist.removeUsStock(ticker);
    } else {
      _watched = await _watchlist.addUsStock(ticker);
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
          for (final entry in spStocks.entries)
            ListTile(
              title: Text('${entry.value.name} (${entry.key})'),
              subtitle: Text(
                'US\$ ${(_prices[entry.key] ?? entry.value.price).toStringAsFixed(2)} · '
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
