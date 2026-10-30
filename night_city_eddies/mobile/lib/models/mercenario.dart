class Mercenario {
  final int id;
  final String nome;
  final String codinome;
  final String especialidade;
  final String distrito;
  final String descricao;
  final int experiencia;
  final double reputacao;
  final int valor;
  final String disponibilidade;
  final String imagem;
  final bool destaque;

  const Mercenario({
    required this.id,
    required this.nome,
    required this.codinome,
    required this.especialidade,
    required this.distrito,
    required this.descricao,
    required this.experiencia,
    required this.reputacao,
    required this.valor,
    required this.disponibilidade,
    required this.imagem,
    required this.destaque,
  });

  factory Mercenario.fromJson(Map<String, dynamic> json) {
    return Mercenario(
      id: json['id'] as int,
      nome: json['nome'] as String,
      codinome: json['codinome'] as String,
      especialidade: json['especialidade'] as String,
      distrito: json['distrito'] as String,
      descricao: json['descricao'] as String,
      experiencia: json['experiencia'] as int,
      reputacao: (json['reputacao'] as num).toDouble(),
      valor: json['valor'] as int,
      disponibilidade: json['disponibilidade'] as String,
      imagem: json['imagem'] as String,
      destaque: (json['destaque'] as int) == 1,
    );
  }
}
