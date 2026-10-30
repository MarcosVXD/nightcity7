class Contratacao {
  final int id;
  final String mercenario;
  final String contrato;
  final String distrito;
  final int valorTotal;
  final String status;
  final String criadoEm;
  final String imagem;

  const Contratacao({
    required this.id,
    required this.mercenario,
    required this.contrato,
    required this.distrito,
    required this.valorTotal,
    required this.status,
    required this.criadoEm,
    required this.imagem,
  });

  factory Contratacao.fromJson(Map<String, dynamic> json) {
    return Contratacao(
      id: json['id'] as int,
      mercenario: json['mercenario'] as String,
      contrato: json['contrato'] as String,
      distrito: json['distrito'] as String,
      valorTotal: json['valor_total'] as int,
      status: json['status'] as String,
      criadoEm: json['criado_em'] as String,
      imagem: json['imagem'] as String,
    );
  }
}
