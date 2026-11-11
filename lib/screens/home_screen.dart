import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ocorrencias_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/metric_card.dart';
import 'about_screen.dart';
import 'form_screen.dart';
import 'list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<OcorrenciasProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('CidadeSegura', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Sobre a iniciativa',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<OcorrenciasProvider>().carregar(),
        child: ListView(padding: const EdgeInsets.all(20), children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(color: AppTheme.azul, borderRadius: BorderRadius.circular(22)),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.location_city_rounded, color: Colors.white, size: 38),
              SizedBox(height: 14),
              Text('Sua cidade merece atenção.',
                  style: TextStyle(fontSize: 25, height: 1.15, color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Registre problemas urbanos e acompanhe a evolução de cada ocorrência.',
                  style: TextStyle(color: Colors.white, height: 1.4)),
            ]),
          ),
          const SizedBox(height: 22),
          Text('Panorama da comunidade', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (estado.carregando) const LinearProgressIndicator(),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.45,
            children: [
              MetricCard(valor: estado.total, rotulo: 'Total de registros', icone: Icons.list_alt, cor: AppTheme.azul),
              MetricCard(valor: estado.abertas, rotulo: 'Abertas', icone: Icons.report_outlined, cor: Colors.red.shade600),
              MetricCard(valor: estado.emAndamento, rotulo: 'Em andamento', icone: Icons.pending_actions, cor: Colors.orange.shade800),
              MetricCard(valor: estado.resolvidas, rotulo: 'Resolvidas', icone: Icons.check_circle_outline, cor: Colors.green.shade700),
            ],
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Registrar ocorrência'),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FormScreen())),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            icon: const Icon(Icons.view_list_outlined),
            label: const Text('Ver todas as ocorrências'),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ListScreen())),
          ),
          const SizedBox(height: 20),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.public, color: AppTheme.destaque),
                SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('ODS 11 · Cidades e comunidades sustentáveis', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('Tecnologia para tornar os espaços urbanos mais seguros, inclusivos e resilientes.'),
                ])),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
