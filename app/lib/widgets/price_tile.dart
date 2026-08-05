import 'package:flutter/material.dart';

class PriceTile extends StatelessWidget {
  final String code;
  final String label;
  final double? price;
  final bool loading;
  final VoidCallback? onRemove;

  /// Prefix shown before the formatted price, e.g. `'R\$ '` or `'US\$ '`.
  /// Leave null for index tiles, which show "pts" as a suffix instead.
  final String? currencyPrefix;

  const PriceTile({
    super.key,
    required this.code,
    required this.label,
    required this.price,
    this.loading = false,
    this.onRemove,
    this.currencyPrefix = 'R\$ ',
  });

  @override
  Widget build(BuildContext context) {
    String formatted;
    if (price == null) {
      formatted = 'Indisponível';
    } else if (currencyPrefix != null) {
      formatted = '$currencyPrefix${price!.toStringAsFixed(2)}';
    } else {
      formatted = '${price!.toStringAsFixed(2)} pts';
    }
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(child: Text(code.characters.first)),
        title: Text('$label ($code)'),
        subtitle: loading ? const Text('Carregando...') : Text(formatted),
        trailing: onRemove == null
            ? null
            : IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Remover',
                onPressed: onRemove,
              ),
      ),
    );
  }
}
