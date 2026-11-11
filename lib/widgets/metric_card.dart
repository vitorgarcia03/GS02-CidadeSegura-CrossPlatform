import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({super.key, required this.valor, required this.rotulo, required this.icone, required this.cor});
  final int valor;
  final String rotulo;
  final IconData icone;
  final Color cor;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icone, color: cor),
            const SizedBox(height: 10),
            Text('$valor', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(rotulo, style: Theme.of(context).textTheme.bodySmall),
          ]),
        ),
      );
}
