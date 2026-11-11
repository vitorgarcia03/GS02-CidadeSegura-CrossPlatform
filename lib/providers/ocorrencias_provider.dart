import 'package:flutter/foundation.dart';

import '../data/ocorrencia_repository.dart';
import '../models/ocorrencia.dart';

class OcorrenciasProvider extends ChangeNotifier {
  OcorrenciasProvider(this._repository);

  final OcorrenciaRepository _repository;
  List<Ocorrencia> _itens = [];
  bool _carregando = false;
  bool _salvando = false;
  String? _erro;

  List<Ocorrencia> get itens => List.unmodifiable(_itens);
  bool get carregando => _carregando;
  bool get salvando => _salvando;
  String? get erro => _erro;
  int get total => _itens.length;
  int get abertas => _itens.where((e) => e.status == 'Aberta').length;
  int get emAndamento => _itens.where((e) => e.status == 'Em andamento').length;
  int get resolvidas => _itens.where((e) => e.status == 'Resolvida').length;
  int get altaPrioridade => _itens.where((e) => e.prioridade == 'Alta').length;

  Ocorrencia? porId(int id) {
    for (final item in _itens) {
      if (item.id == id) return item;
    }
    return null;
  }

  Future<void> carregar() async {
    _carregando = true;
    _erro = null;
    notifyListeners();
    try {
      _itens = await _repository.listar();
    } catch (_) {
      _erro = 'Não foi possível carregar os registros. Tente novamente.';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<bool> adicionar(Ocorrencia ocorrencia) async {
    _salvando = true;
    _erro = null;
    notifyListeners();
    try {
      final criado = await _repository.criar(ocorrencia);
      _itens = [criado, ..._itens];
      return true;
    } catch (_) {
      _erro = 'Não foi possível salvar a ocorrência.';
      return false;
    } finally {
      _salvando = false;
      notifyListeners();
    }
  }

  Future<bool> editar(Ocorrencia ocorrencia) async {
    _salvando = true;
    _erro = null;
    notifyListeners();
    try {
      await _repository.atualizar(ocorrencia);
      _itens = [for (final item in _itens) if (item.id == ocorrencia.id) ocorrencia else item];
      return true;
    } catch (_) {
      _erro = 'Não foi possível atualizar a ocorrência.';
      return false;
    } finally {
      _salvando = false;
      notifyListeners();
    }
  }

  Future<bool> excluir(int id) async {
    _salvando = true;
    _erro = null;
    notifyListeners();
    try {
      await _repository.excluir(id);
      _itens = _itens.where((e) => e.id != id).toList();
      return true;
    } catch (_) {
      _erro = 'Não foi possível excluir a ocorrência.';
      return false;
    } finally {
      _salvando = false;
      notifyListeners();
    }
  }
}
