import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ocorrencias_provider.dart';
import '../widgets/ocorrencia_card.dart';
import 'detail_screen.dart';
import 'form_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  String _filtro = 'Todas';

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<OcorrenciasProvider>();
    final filtradas = estado.itens.where((e) => _filtro == 'Todas' || e.status == _filtro).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Ocorrências')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FormScreen())),
        icon: const Icon(Icons.add),
        label: const Text('Nova'),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: DropdownButtonFormField<String>(
            initialValue: _filtro,
            decoration: const InputDecoration(labelText: 'Filtrar por status', prefixIcon: Icon(Icons.filter_list)),
            items: ['Todas', 'Aberta', 'Em andamento', 'Resolvida']
                .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => _filtro = v ?? 'Todas'),
          ),
        ),
        Expanded(
          child: estado.carregando
              ? const Center(child: CircularProgressIndicator())
              : estado.erro != null
                  ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.error_outline, size: 44),
                      const SizedBox(height: 10),
                      Padding(padding: const EdgeInsets.all(12), child: Text(estado.erro!, textAlign: TextAlign.center)),
                      TextButton(onPressed: () => context.read<OcorrenciasProvider>().carregar(), child: const Text('Tentar novamente')),
                    ]))
                  : filtradas.isEmpty
                      ? Center(child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.inbox_outlined, size: 60, color: Colors.grey),
                            const SizedBox(height: 12),
                            const Text('Nenhuma ocorrência encontrada.', textAlign: TextAlign.center),
                            const SizedBox(height: 8),
                            Text(_filtro == 'Todas' ? 'Toque em Nova para começar.' : 'Tente outro filtro.'),
                          ]),
                        ))
                      : RefreshIndicator(
                          onRefresh: () => context.read<OcorrenciasProvider>().carregar(),
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
                            itemCount: filtradas.length,
                            itemBuilder: (context, i) => OcorrenciaCard(
                              ocorrencia: filtradas[i],
                              onTap: () => Navigator.push(context, MaterialPageRoute(
                                builder: (_) => DetailScreen(ocorrenciaId: filtradas[i].id!),
                              )),
                            ),
                          ),
                        ),
        ),
      ]),
    );
  }
}
