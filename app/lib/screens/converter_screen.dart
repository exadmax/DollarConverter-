import 'package:flutter/material.dart';

import '../models/market_data.dart';
import '../services/exchange_service.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final _exchange = ExchangeService();
  final _valueController = TextEditingController(text: '1');
  String _from = 'USD';
  String _to = 'BRL';
  String _result = '';
  bool _loading = false;

  Future<void> _convert() async {
    final value = double.tryParse(_valueController.text.replaceAll(',', '.'));
    if (value == null) {
      setState(() => _result = 'Valor inválido.');
      return;
    }
    setState(() {
      _loading = true;
      _result = '';
    });
    try {
      final converted = await _exchange.convert(value, _from, _to);
      setState(() {
        _result = '${value.toStringAsFixed(4)} $_from = ${converted.toStringAsFixed(4)} $_to';
      });
    } on QuoteApiException {
      setState(() => _result = 'API de cotações indisponível.');
    } catch (_) {
      setState(() => _result = 'Não foi possível converter.');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final codes = currencyNames.keys.toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _valueController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Valor', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _from,
            decoration: const InputDecoration(labelText: 'De', border: OutlineInputBorder()),
            items: [
              for (final c in codes) DropdownMenuItem(value: c, child: Text('${currencyNames[c]} ($c)')),
            ],
            onChanged: (v) => setState(() => _from = v!),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _to,
            decoration: const InputDecoration(labelText: 'Para', border: OutlineInputBorder()),
            items: [
              for (final c in codes) DropdownMenuItem(value: c, child: Text('${currencyNames[c]} ($c)')),
            ],
            onChanged: (v) => setState(() => _to = v!),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _loading ? null : _convert,
            child: _loading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Converter'),
          ),
          const SizedBox(height: 24),
          if (_result.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_result, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
              ),
            ),
        ],
      ),
    );
  }
}
