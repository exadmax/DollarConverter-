import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/market_data.dart';

/// Shows the monthly appreciation percentage (last 6 months) of a
/// selected currency or B3 stock, based on the illustrative offline
/// history table (the same data used as fallback elsewhere).
class AppreciationScreen extends StatefulWidget {
  const AppreciationScreen({super.key});

  @override
  State<AppreciationScreen> createState() => _AppreciationScreenState();
}

class _AppreciationScreenState extends State<AppreciationScreen> {
  bool _showCurrencies = true;
  String _selected = 'BTC';

  @override
  Widget build(BuildContext context) {
    final options = _showCurrencies ? currencyHistoryBrl.keys.toList() : b3Stocks.keys.toList();
    if (!options.contains(_selected)) _selected = options.first;

    final history = _showCurrencies ? currencyHistoryBrl[_selected]! : b3Stocks[_selected]!.monthly;
    final appreciation = monthlyAppreciation(history);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Moedas')),
              ButtonSegment(value: false, label: Text('Ações B3')),
            ],
            selected: {_showCurrencies},
            onSelectionChanged: (s) => setState(() => _showCurrencies = s.first),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selected,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Selecione'),
            items: [for (final o in options) DropdownMenuItem(value: o, child: Text(o))],
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
