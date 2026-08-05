import 'package:flutter/material.dart';

import '../services/simulator.dart';

class SimulatorScreen extends StatefulWidget {
  const SimulatorScreen({super.key});

  @override
  State<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends State<SimulatorScreen> {
  final _metaController = TextEditingController();
  final _rendimentoController = TextEditingController(text: '3');
  String _resultado = '';

  void _simular() {
    final meta = double.tryParse(_metaController.text.replaceAll(',', '.'));
    final rendimento = double.tryParse(_rendimentoController.text.replaceAll(',', '.'));
    if (meta == null || rendimento == null) {
      setState(() => _resultado = 'Preencha os campos corretamente.');
      return;
    }
    try {
      final investimento = investmentForWeeklyProfit(meta, rendimento);
      setState(() {
        _resultado =
            'Para lucrar R\$${meta.toStringAsFixed(2)}/semana com ${rendimento.toStringAsFixed(2)}%, '
            'você precisa investir R\$${investimento.toStringAsFixed(2)}';
      });
    } on ArgumentError catch (e) {
      setState(() => _resultado = e.message as String);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _metaController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Meta semanal (R\$)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _rendimentoController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Rendimento médio semanal (%)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _simular, child: const Text('Simular')),
          const SizedBox(height: 24),
          if (_resultado.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_resultado, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
              ),
            ),
        ],
      ),
    );
  }
}
