class Contrato {
  final int id;
  final String titulo;
  final String categoria;
  final String distrito;
  final String dificuldade;
  final String descricao;
  final int recompensa;
  final String prazo;

  const Contrato({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.distrito,
    required this.dificuldade,
    required this.descricao,
    required this.recompensa,
    required this.prazo,
  });

  factory Contrato.fromJson(Map<String, dynamic> json) {
    return Contrato(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      categoria: json['categoria'] as String,
      distrito: json['distrito'] as String,
      dificuldade: json['dificuldade'] as String,
      descricao: json['descricao'] as String,
      recompensa: json['recompensa'] as int,
      prazo: json['prazo'] as String,
    );
  }
}
