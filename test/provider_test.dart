import 'package:flutter_test/flutter_test.dart';
import 'package:cidadesegura/data/ocorrencia_repository.dart';
import 'package:cidadesegura/models/ocorrencia.dart';
import 'package:cidadesegura/providers/ocorrencias_provider.dart';

class RepositorioEmMemoria implements OcorrenciaRepository {
  final List<Ocorrencia> registros = [];
  int proximoId = 1;
  bool falhaListagem = false;

  @override
  Future<List<Ocorrencia>> listar() async {
    if (falhaListagem) throw StateError('Erro simulado');
    return List.of(registros);
  }

  @override
  Future<Ocorrencia> criar(Ocorrencia ocorrencia) async {
    final novo = ocorrencia.copyWith(id: proximoId++);
    registros.insert(0, novo);
    return novo;
  }

  @override
  Future<void> atualizar(Ocorrencia ocorrencia) async {
    final index = registros.indexWhere((i) => i.id == ocorrencia.id);
    if (index < 0) throw StateError('Não encontrado');
    registros[index] = ocorrencia;
  }

  @override
  Future<void> excluir(int id) async {
    final antes = registros.length;
    registros.removeWhere((i) => i.id == id);
    if (registros.length == antes) throw StateError('Não encontrado');
  }
}

void main() {
  final agora = DateTime(2026, 11, 10);
  Ocorrencia nova({String status = 'Aberta', String prioridade = 'Alta'}) => Ocorrencia(
        titulo: 'Buraco perigoso',
        descricao: 'Buraco muito grande na rua.',
        categoria: 'Buracos na via',
        bairro: 'Centro',
        endereco: 'Rua A, 123',
        prioridade: prioridade,
        status: status,
        criadoEm: agora,
        atualizadoEm: agora,
      );

  test('13 - provider inicia com lista vazia', () async {
    final p = OcorrenciasProvider(RepositorioEmMemoria());
    await p.carregar();
    expect(p.total, 0);
    expect(p.carregando, false);
    p.dispose();
  });

  test('14 - criar ocorrência atualiza lista reativamente', () async {
    final p = OcorrenciasProvider(RepositorioEmMemoria());
    var avisos = 0;
    p.addListener(() => avisos++);
    expect(await p.adicionar(nova()), true);
    expect(p.total, 1);
    expect(p.itens.first.id, isNotNull);
    expect(avisos, greaterThan(0));
    p.dispose();
  });

  test('15 - editar altera status e indicadores', () async {
    final p = OcorrenciasProvider(RepositorioEmMemoria());
    await p.adicionar(nova());
    final item = p.itens.first;
    expect(await p.editar(item.copyWith(status: 'Resolvida')), true);
    expect(p.resolvidas, 1);
    expect(p.abertas, 0);
    p.dispose();
  });

  test('16 - excluir remove ocorrência', () async {
    final p = OcorrenciasProvider(RepositorioEmMemoria());
    await p.adicionar(nova());
    expect(await p.excluir(p.itens.first.id!), true);
    expect(p.itens, isEmpty);
    p.dispose();
  });

  test('17 - indicadores contabilizam status e prioridade', () async {
    final p = OcorrenciasProvider(RepositorioEmMemoria());
    await p.adicionar(nova());
    await p.adicionar(nova(status: 'Em andamento', prioridade: 'Baixa'));
    expect(p.total, 2);
    expect(p.abertas, 1);
    expect(p.emAndamento, 1);
    expect(p.altaPrioridade, 1);
    p.dispose();
  });

  test('18 - erro de carregamento é apresentado sem travar', () async {
    final repo = RepositorioEmMemoria()..falhaListagem = true;
    final p = OcorrenciasProvider(repo);
    await p.carregar();
    expect(p.erro, isNotNull);
    expect(p.carregando, false);
    p.dispose();
  });

  test('19 - recuperar carregamento limpa erro anterior', () async {
    final repo = RepositorioEmMemoria()..falhaListagem = true;
    final p = OcorrenciasProvider(repo);
    await p.carregar();
    repo.falhaListagem = false;
    await p.carregar();
    expect(p.erro, isNull);
    p.dispose();
  });

  test('20 - exclusão inexistente retorna false', () async {
    final p = OcorrenciasProvider(RepositorioEmMemoria());
    expect(await p.excluir(999), false);
    expect(p.erro, isNotNull);
    p.dispose();
  });

  test('21 - consulta por id encontra registro criado', () async {
    final p = OcorrenciasProvider(RepositorioEmMemoria());
    await p.adicionar(nova());
    expect(p.porId(p.itens.first.id!)?.titulo, 'Buraco perigoso');
    expect(p.porId(999), isNull);
    p.dispose();
  });
}
