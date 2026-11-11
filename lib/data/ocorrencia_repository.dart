import '../models/ocorrencia.dart';

abstract class OcorrenciaRepository {
  Future<List<Ocorrencia>> listar();
  Future<Ocorrencia> criar(Ocorrencia ocorrencia);
  Future<void> atualizar(Ocorrencia ocorrencia);
  Future<void> excluir(int id);
}
