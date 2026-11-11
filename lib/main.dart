import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/sqlite_ocorrencia_repository.dart';
import 'providers/ocorrencias_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => OcorrenciasProvider(SqliteOcorrenciaRepository())..carregar(),
      child: const CidadeSeguraApp(),
    ),
  );
}

class CidadeSeguraApp extends StatelessWidget {
  const CidadeSeguraApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'CidadeSegura',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const HomeScreen(),
      );
}
