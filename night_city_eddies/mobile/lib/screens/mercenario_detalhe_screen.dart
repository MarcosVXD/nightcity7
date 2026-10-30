import 'package:flutter/material.dart';
import '../models/mercenario.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import 'checkout_screen.dart';

class MercenarioDetalheScreen extends StatelessWidget {
  final Mercenario mercenario;
  const MercenarioDetalheScreen({super.key, required this.mercenario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.fundo,
      appBar: AppBar(title: const Text('PERFIL DO OPERADOR', style: TextStyle(letterSpacing: 1.2, fontSize: 13))),
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 340,
                width: double.infinity,
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF333016), Color(0xFF17191D), AppTheme.fundo], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: Stack(children: [
                  Positioned.fill(child: Image.network(mercenario.imagem, fit: BoxFit.contain, alignment: Alignment.bottomCenter, errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 130, color: AppTheme.amarelo))),
                  Positioned(left: 18, top: 18, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7), color: AppTheme.amarelo, child: Text(mercenario.codinome, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1)))),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [const Icon(Icons.star, color: AppTheme.amarelo, size: 18), const SizedBox(width: 5), Text(mercenario.reputacao.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), const SizedBox(width: 12), Text('${mercenario.experiencia} anos de experiência', style: const TextStyle(color: Colors.white54, fontSize: 11))]),
                  const SizedBox(height: 10),
                  Text(mercenario.nome, style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 5),
                  Text(mercenario.especialidade.toUpperCase(), style: const TextStyle(color: AppTheme.amarelo, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 22),
                  const SectionTitle('Sobre o operador'),
                  const SizedBox(height: 8),
                  Text(mercenario.descricao, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.6)),
                  const SizedBox(height: 22),
                  _linha(Icons.location_on_outlined, 'DISTRITO', mercenario.distrito),
                  _linha(Icons.verified_user_outlined, 'DISPONIBILIDADE', mercenario.disponibilidade),
                  _linha(Icons.military_tech, 'REPUTAÇÃO', '${mercenario.reputacao.toStringAsFixed(1)} / 5.0'),
                  const SizedBox(height: 14),
                  const Text('A contratação é fictícia e não realiza pagamentos reais.', style: TextStyle(color: Colors.white30, fontSize: 10)),
                ]),
              ),
            ]),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 13, 20, 20),
          decoration: const BoxDecoration(color: AppTheme.painel, border: Border(top: BorderSide(color: Color(0xFF303238)))),
          child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('TAXA DO OPERADOR', style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1)), const SizedBox(height: 4), Text(dinheiro(mercenario.valor), style: const TextStyle(color: AppTheme.amarelo, fontSize: 20, fontWeight: FontWeight.w900))])), ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutScreen(mercenario: mercenario))), icon: const Icon(Icons.handshake_outlined), label: const Text('CONTRATAR'))]),
        ),
      ]),
    );
  }

  Widget _linha(IconData icone, String titulo, String valor) => Padding(padding: const EdgeInsets.only(bottom: 14), child: Row(children: [Icon(icone, color: AppTheme.amarelo, size: 20), const SizedBox(width: 12), SizedBox(width: 112, child: Text(titulo, style: const TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1))), Expanded(child: Text(valor, style: const TextStyle(color: Colors.white, fontSize: 12)))]));
}
