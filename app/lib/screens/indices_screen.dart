import 'package:flutter/material.dart';

import '../models/market_data.dart';
import '../services/b3_service.dart';

/// Dedicated screen for the market indices (Ibovespa, IFIX, S&P 500),
/// shown alongside "Ações B3" in the navigation. Indices are fixed —
/// unlike stocks/currencies, the user can't add or remove them here.
class IndicesScreen extends StatefulWidget {
  const IndicesScreen({super.key});

  @override
  State<IndicesScreen> createState() => _IndicesScreenState();
}

class _IndicesScreenState extends State<IndicesScreen> {
  final _b3 = B3Service();
  Map<String, double> _prices = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _prices = await _b3.getAllPricesBrl(indexLabels.keys.toList());
    if (!mounted) return;
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        children: [
          for (final entry in indexLabels.entries)
            ListTile(
              leading: CircleAvatar(child: Text(entry.value.characters.first)),
              title: Text(entry.value),
              subtitle: Text(
                _prices[entry.key] == null
                    ? 'Indisponível'
                    : '${_prices[entry.key]!.toStringAsFixed(2)} pts',
              ),
            ),
        ],
      ),
    );
  }
}
