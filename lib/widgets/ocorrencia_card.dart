import 'package:flutter/material.dart';
import '../models/ocorrencia.dart';
import '../theme/app_theme.dart';

class OcorrenciaCard extends StatelessWidget {
  const OcorrenciaCard({super.key, required this.ocorrencia, required this.onTap});
  final Ocorrencia ocorrencia;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cor = switch (ocorrencia.status) {
      'Resolvida' => Colors.green.shade700,
      'Em andamento' => Colors.orange.shade800,
      _ => AppTheme.azul,
    };
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(ocorrencia.titulo,
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.grey.shade500),
            ]),
            const SizedBox(height: 8),
            Text('${ocorrencia.categoria} · ${ocorrencia.bairro}',
                maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 6, children: [
              Chip(
                label: Text(ocorrencia.status),
                labelStyle: TextStyle(color: cor, fontWeight: FontWeight.w600),
                backgroundColor: cor.withValues(alpha: 0.10),
                side: BorderSide.none,
                visualDensity: VisualDensity.compact,
              ),
              Chip(
                label: Text('Prioridade ${ocorrencia.prioridade.toLowerCase()}'),
                visualDensity: VisualDensity.compact,
                side: BorderSide(color: Colors.grey.shade200),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
