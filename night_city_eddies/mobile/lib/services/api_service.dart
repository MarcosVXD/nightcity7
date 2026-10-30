import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mercenario.dart';
import '../models/contrato.dart';
import '../models/contratacao.dart';

class ApiService {
  // Android Emulator: 10.0.2.2 aponta para o computador.
  // Para celular físico, substitua pelo IP local do computador.
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.2.2:3000/api',
  );

  static Uri _url(String caminho) => Uri.parse('$baseUrl$caminho');

  static Future<List<dynamic>> _getLista(String caminho) async {
    final resposta = await http.get(_url(caminho)).timeout(
      const Duration(seconds: 12),
    );

    if (resposta.statusCode != 200) {
      throw Exception('Erro ${resposta.statusCode} ao consultar a API.');
    }

    return jsonDecode(utf8.decode(resposta.bodyBytes)) as List<dynamic>;
  }

  static Future<List<Mercenario>> buscarMercenarios() async {
    final dados = await _getLista('/mercenarios');
    return dados
        .map((item) => Mercenario.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<List<Contrato>> buscarContratos() async {
    final dados = await _getLista('/contratos');
    return dados
        .map((item) => Contrato.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<List<Contratacao>> buscarContratacoes() async {
    final dados = await _getLista('/contratacoes');
    return dados
        .map((item) => Contratacao.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<void> contratar(int mercenarioId, int contratoId) async {
    final resposta = await http
        .post(
          _url('/contratacoes'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'mercenarioId': mercenarioId,
            'contratoId': contratoId,
          }),
        )
        .timeout(const Duration(seconds: 12));

    if (resposta.statusCode != 201) {
      final dados = jsonDecode(utf8.decode(resposta.bodyBytes));
      throw Exception(dados['erro'] ?? 'Não foi possível criar a contratação.');
    }
  }

  static Future<void> cancelarContratacao(int id) async {
    final resposta = await http.patch(
      _url('/contratacoes/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': 'Cancelado'}),
    );

    if (resposta.statusCode != 200) {
      throw Exception('Não foi possível cancelar a contratação.');
    }
  }
}
