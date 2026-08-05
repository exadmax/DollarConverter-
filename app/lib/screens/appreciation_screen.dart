import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/market_data.dart';

enum _Category { currencies, stocks, usStocks, indices }

/// Shows the monthly appreciation percentage (last 6 months) of a
/// selected currency, B3 stock, S&P 500 stock or market index
/// (Ibovespa/IFIX/S&P 500), based on the illustrative offline history
/// table (the same data used as fallback elsewhere).
class AppreciationScreen extends StatefulWidget {
  const AppreciationScreen({super.key});

  @override
  State<AppreciationScreen> createState() => _AppreciationScreenState();
}

class _AppreciationScreenState extends State<AppreciationScreen> {
  _Category _category = _Category.currencies;
  String _selected = 'BTC';

  List<String> _optionsFor(_Category category) {
    switch (category) {
      case _Category.currencies:
        return currencyHistoryBrl.keys.toList();
      case _Category.stocks:
        return b3Stocks.keys.toList();
      case _Category.usStocks:
        return spStocks.keys.toList();
      case _Category.indices:
        return indexLabels.keys.toList();
    }
  }

  List<double> _historyFor(_Category category, String selected) {
    switch (category) {
      case _Category.currencies:
        return currencyHistoryBrl[selected]!;
      case _Category.stocks:
        return b3Stocks[selected]!.monthly;
      case _Category.usStocks:
        return spStocks[selected]!.monthly;
      case _Category.indices:
        return indexHistoryPoints[selected]!;
    }
  }

  String _labelFor(_Category category, String option) {
    if (category == _Category.indices) return indexLabels[option]!;
    return option;
  }

  @override
  Widget build(BuildContext context) {
    final options = _optionsFor(_category);
    if (!options.contains(_selected)) _selected = options.first;

    final history = _historyFor(_category, _selected);
    final appreciation = monthlyAppreciation(history);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<_Category>(
              segments: const [
                ButtonSegment(value: _Category.currencies, label: Text('Moedas')),
                ButtonSegment(value: _Category.stocks, label: Text('Ações B3')),
                ButtonSegment(value: _Category.usStocks, label: Text('Ações S&P 500')),
                ButtonSegment(value: _Category.indices, label: Text('Índices')),
              ],
              selected: {_category},
              onSelectionChanged: (s) => setState(() => _category = s.first),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selected,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Selecione'),
            items: [
              for (final o in options) DropdownMenuItem(value: o, child: Text(_labelFor(_category, o))),
            ],
            onChanged: (v) => setState(() => _selected = v!),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                minY: appreciation.reduce((a, b) => a < b ? a : b) - 1,
                maxY: appreciation.reduce((a, b) => a > b ? a : b) + 1,
                gridData: const FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      getTitlesWidget: (value, meta) => Text('${value.toStringAsFixed(0)}%'),
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text('M${value.toInt() + 1}'),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) => spots
                        .map((s) => LineTooltipItem('${s.y.toStringAsFixed(2)}%', const TextStyle(color: Colors.white)))
                        .toList(),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [for (var i = 0; i < appreciation.length; i++) FlSpot(i.toDouble(), appreciation[i])],
                    isCurved: true,
                    barWidth: 3,
                    color: Theme.of(context).colorScheme.primary,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                        radius: 4,
                        color: spot.y >= 0 ? Colors.green : Colors.red,
                        strokeWidth: 0,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Variação percentual mês a mês (dados ilustrativos offline).',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
