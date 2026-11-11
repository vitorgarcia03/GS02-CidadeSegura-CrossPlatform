class Validadores {
  static String? titulo(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) return 'Informe o título da ocorrência.';
    if (texto.length < 5) return 'Use pelo menos 5 caracteres.';
    if (texto.length > 80) return 'Use no máximo 80 caracteres.';
    return null;
  }

  static String? descricao(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) return 'Descreva o problema.';
    if (texto.length < 10) return 'Use pelo menos 10 caracteres.';
    if (texto.length > 500) return 'Use no máximo 500 caracteres.';
    return null;
  }

  static String? local(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) return 'Este campo é obrigatório.';
    if (texto.length < 3) return 'Use pelo menos 3 caracteres.';
    if (texto.length > 120) return 'Use no máximo 120 caracteres.';
    return null;
  }

  static String? escolha(String? valor, List<String> permitidos) =>
      permitidos.contains(valor) ? null : 'Selecione uma opção válida.';
}
