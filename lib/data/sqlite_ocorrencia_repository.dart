import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../models/ocorrencia.dart';
import 'ocorrencia_repository.dart';

class SqliteOcorrenciaRepository implements OcorrenciaRepository {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    _database = await openDatabase(
      path.join(dbPath, 'cidadesegura.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ocorrencias (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            descricao TEXT NOT NULL,
            categoria TEXT NOT NULL,
            bairro TEXT NOT NULL,
            endereco TEXT NOT NULL,
            prioridade TEXT NOT NULL,
            status TEXT NOT NULL,
            criado_em TEXT NOT NULL,
            atualizado_em TEXT NOT NULL
          )
        ''');
      },
    );
    return _database!;
  }

  @override
  Future<List<Ocorrencia>> listar() async {
    final db = await database;
    final linhas = await db.query('ocorrencias', orderBy: 'criado_em DESC, id DESC');
    return linhas.map(Ocorrencia.fromMap).toList();
  }

  @override
  Future<Ocorrencia> criar(Ocorrencia ocorrencia) async {
    final db = await database;
    final valores = ocorrencia.toMap()..remove('id');
    final id = await db.insert('ocorrencias', valores);
    return ocorrencia.copyWith(id: id);
  }

  @override
  Future<void> atualizar(Ocorrencia ocorrencia) async {
    final id = ocorrencia.id;
    if (id == null) throw ArgumentError('Ocorrência sem identificador.');
    final db = await database;
    final valores = ocorrencia.toMap()..remove('id');
    final alterados = await db.update('ocorrencias', valores,
        where: 'id = ?', whereArgs: [id]);
    if (alterados == 0) throw StateError('Ocorrência não encontrada.');
  }

  @override
  Future<void> excluir(int id) async {
    final db = await database;
    final excluidos = await db.delete('ocorrencias', where: 'id = ?', whereArgs: [id]);
    if (excluidos == 0) throw StateError('Ocorrência não encontrada.');
  }
}
