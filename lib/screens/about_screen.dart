import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Sobre o CidadeSegura')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          const Icon(Icons.volunteer_activism_outlined, size: 64, color: AppTheme.destaque),
          const SizedBox(height: 16),
          Text('Tecnologia feita para a comunidade',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text('O CidadeSegura é um MVP CitizenTech que facilita o registro e o acompanhamento local de ocorrências de infraestrutura e segurança urbana.'),
          const SizedBox(height: 18),
          const Card(child: Padding(
            padding: EdgeInsets.all(18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('ODS 11 — Cidades e comunidades sustentáveis', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('O aplicativo contribui para a organização de informações sobre problemas urbanos e incentiva a participação cidadã.'),
              SizedBox(height: 14),
              Text('Privacidade e escopo', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Os dados ficam apenas neste dispositivo (SQLite). Este protótipo não encaminha solicitações automaticamente à prefeitura ou a serviços de emergência.'),
            ]),
          )),
          const SizedBox(height: 20),
          const Text('FIAP · Global Solution 2026.2'),
          const Text('Caíque de Lacerda Braga · RM555532'),
          const Text('Vitor Garcia Correia · RM558516'),
        ]),
      );
}
