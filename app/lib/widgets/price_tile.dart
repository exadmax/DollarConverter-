import 'package:flutter/material.dart';

class PriceTile extends StatelessWidget {
  final String code;
  final String label;
  final double? price;
  final bool loading;
  final VoidCallback? onRemove;

  const PriceTile({
    super.key,
    required this.code,
    required this.label,
    required this.price,
    this.loading = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(child: Text(code.characters.first)),
        title: Text('$label ($code)'),
        subtitle: loading
            ? const Text('Carregando...')
            : Text(price == null ? 'Indisponível' : 'R\$ ${price!.toStringAsFixed(2)}'),
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
