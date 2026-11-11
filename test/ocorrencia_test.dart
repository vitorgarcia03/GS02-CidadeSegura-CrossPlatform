import 'package:flutter_test/flutter_test.dart';
import 'package:cidadesegura/models/ocorrencia.dart';
import 'package:cidadesegura/utils/validadores.dart';

void main() {
  final agora = DateTime(2026, 11, 10, 10, 30);
  Ocorrencia exemplo() => Ocorrencia(
        id: 7,
        titulo: 'Poste sem luz',
        descricao: 'O poste está apagado há dias.',
        categoria: 'Iluminação pública',
        bairro: 'Centro',
        endereco: 'Rua das Flores, 10',
        prioridade: 'Alta',
        status: 'Aberta',
        criadoEm: agora,
        atualizadoEm: agora,
      );

  test('01 - serializa ocorrência para SQLite', () {
    final map = exemplo().toMap();
    expect(map['id'], 7);
    expect(map['titulo'], 'Poste sem luz');
    expect(map['criado_em'], agora.toIso8601String());
  });

  test('02 - desserializa ocorrência do SQLite', () {
    final item = Ocorrencia.fromMap(exemplo().toMap());
    expect(item.id, 7);
    expect(item.endereco, 'Rua das Flores, 10');
    expect(item.criadoEm, agora);
  });

  test('03 - copyWith mantém campos não informados', () {
    final item = exemplo().copyWith(status: 'Resolvida');
    expect(item.titulo, 'Poste sem luz');
    expect(item.status, 'Resolvida');
    expect(item.id, 7);
  });

  test('04 - título vazio é rejeitado', () {
    expect(Validadores.titulo('   '), isNotNull);
  });

  test('05 - título curto é rejeitado', () {
    expect(Validadores.titulo('Oi'), isNotNull);
  });

  test('06 - título válido é aceito', () {
    expect(Validadores.titulo('Buraco na rua'), isNull);
  });

  test('07 - descrição insuficiente é rejeitada', () {
    expect(Validadores.descricao('curta'), isNotNull);
  });

  test('08 - descrição válida é aceita', () {
    expect(Validadores.descricao('Existe um buraco profundo na rua.'), isNull);
  });

  test('09 - bairro vazio é rejeitado', () {
    expect(Validadores.local(''), isNotNull);
  });

  test('10 - endereço válido é aceito', () {
    expect(Validadores.local('Av. Paulista, 100'), isNull);
  });

  test('11 - categoria desconhecida é rejeitada', () {
    expect(Validadores.escolha('Categoria inventada', Ocorrencia.categorias), isNotNull);
  });

  test('12 - prioridade permitida é aceita', () {
    expect(Validadores.escolha('Alta', Ocorrencia.prioridades), isNull);
  });
}
