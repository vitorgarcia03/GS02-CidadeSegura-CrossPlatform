import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/ocorrencia.dart';
import '../providers/ocorrencias_provider.dart';
import 'form_screen.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.ocorrenciaId});
  final int ocorrenciaId;

  Future<void> _confirmarExclusao(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir ocorrência?'),
        content: const Text('Essa ação não pode ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Excluir')),
        ],
      ),
    );
    if (confirmar != true || !context.mounted) return;
    final provider = context.read<OcorrenciasProvider>();
    final sucesso = await provider.excluir(ocorrenciaId);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(sucesso ? 'Ocorrência excluída com sucesso!' : (provider.erro ?? 'Erro ao excluir.')),
    ));
    if (sucesso) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OcorrenciasProvider>();
    final item = provider.porId(ocorrenciaId);
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da ocorrência')),
      body: item == null
          ? const Center(child: Text('Registro não encontrado.'))
          : ListView(padding: const EdgeInsets.all(20), children: [
              Text(item.titulo,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _campo('Descrição', item.descricao),
                  _campo('Categoria', item.categoria),
                  _campo('Bairro', item.bairro),
                  _campo('Endereço / referência', item.endereco),
                  _campo('Prioridade', item.prioridade),
                  _campo('Status', item.status),
                  _campo('Criado em', _data(item.criadoEm)),
                  _campo('Atualizado em', _data(item.atualizadoEm), ultimo: true),
                ],
              ))),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: provider.salvando ? null : () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => FormScreen(ocorrencia: item)),
                ),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar ocorrência'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: provider.salvando ? null : () => _confirmarExclusao(context),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text('Excluir ocorrência', style: TextStyle(color: Colors.red)),
              ),
            ]),
    );
  }

  String _data(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  Widget _campo(String titulo, String valor, {bool ultimo = false}) => Padding(
        padding: EdgeInsets.only(bottom: ultimo ? 0 : 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(titulo, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(valor, style: const TextStyle(fontSize: 16)),
        ]),
      );
}
