class Ocorrencia {
  const Ocorrencia({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.bairro,
    required this.endereco,
    required this.prioridade,
    required this.status,
    required this.criadoEm,
    required this.atualizadoEm,
  });

  final int? id;
  final String titulo;
  final String descricao;
  final String categoria;
  final String bairro;
  final String endereco;
  final String prioridade;
  final String status;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  static const categorias = [
    'Iluminação pública',
    'Buracos na via',
    'Lixo e entulho',
    'Enchente',
    'Sinalização',
    'Outros',
  ];
  static const prioridades = ['Baixa', 'Média', 'Alta'];
  static const statusPossiveis = ['Aberta', 'Em andamento', 'Resolvida'];

  Ocorrencia copyWith({
    int? id,
    String? titulo,
    String? descricao,
    String? categoria,
    String? bairro,
    String? endereco,
    String? prioridade,
    String? status,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) => Ocorrencia(
        id: id ?? this.id,
        titulo: titulo ?? this.titulo,
        descricao: descricao ?? this.descricao,
        categoria: categoria ?? this.categoria,
        bairro: bairro ?? this.bairro,
        endereco: endereco ?? this.endereco,
        prioridade: prioridade ?? this.prioridade,
        status: status ?? this.status,
        criadoEm: criadoEm ?? this.criadoEm,
        atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'titulo': titulo,
        'descricao': descricao,
        'categoria': categoria,
        'bairro': bairro,
        'endereco': endereco,
        'prioridade': prioridade,
        'status': status,
        'criado_em': criadoEm.toIso8601String(),
        'atualizado_em': atualizadoEm.toIso8601String(),
      };

  factory Ocorrencia.fromMap(Map<String, Object?> map) => Ocorrencia(
        id: map['id'] as int?,
        titulo: map['titulo'] as String,
        descricao: map['descricao'] as String,
        categoria: map['categoria'] as String,
        bairro: map['bairro'] as String,
        endereco: map['endereco'] as String,
        prioridade: map['prioridade'] as String,
        status: map['status'] as String,
        criadoEm: DateTime.parse(map['criado_em'] as String),
        atualizadoEm: DateTime.parse(map['atualizado_em'] as String),
      );
}
