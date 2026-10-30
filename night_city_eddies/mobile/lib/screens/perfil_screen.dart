import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class PerfilScreen extends StatelessWidget {
  final VoidCallback abrirFavoritos;
  const PerfilScreen({super.key, required this.abrirFavoritos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PERFIL DO CONTRATANTE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.1))),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppTheme.painel, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.amarelo.withOpacity(0.35))),
          child: Column(children: [
            const CircleAvatar(radius: 42, backgroundColor: Color(0xFF333016), child: Icon(Icons.person, color: AppTheme.amarelo, size: 45)),
            const SizedBox(height: 12),
            const Text('CONTRATANTE // V', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 5),
            const Text('NIGHT CITY • WATSON', style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1.5)),
            const SizedBox(height: 18),
            Container(height: 1, color: const Color(0xFF303238)),
            const SizedBox(height: 17),
            const Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _PerfilNumero(valor: '12', rotulo: 'CONTRATOS'),
              _PerfilNumero(valor: '04', rotulo: 'CONCLUÍDOS'),
              _PerfilNumero(valor: 'LV. 12', rotulo: 'REPUTAÇÃO'),
            ]),
          ]),
        ),
        const SizedBox(height: 22),
        const Text('CARTEIRA DIGITAL', style: TextStyle(color: AppTheme.amarelo, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: const Color(0xFF272511), borderRadius: BorderRadius.circular(13)), child: const Row(children: [Icon(Icons.account_balance_wallet_outlined, color: AppTheme.amarelo, size: 30), SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('SALDO SIMULADO', style: TextStyle(color: Colors.white54, fontSize: 9, letterSpacing: 1.3)), SizedBox(height: 5), Text('€\$ 125.000', style: TextStyle(color: AppTheme.amarelo, fontSize: 24, fontWeight: FontWeight.w900))]))])),
        const SizedBox(height: 22),
        const Text('MINHA CONTA', style: TextStyle(color: AppTheme.amarelo, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _opcao(Icons.bookmark_border, 'Mercenários favoritos', abrirFavoritos),
        _opcao(Icons.security, 'Segurança da conta', () => _aviso(context, 'Área demonstrativa. Login não está implementado nesta versão.')),
        _opcao(Icons.settings_outlined, 'Configurações', () => _aviso(context, 'Configurações futuras do aplicativo.')),
        _opcao(Icons.info_outline, 'Sobre o projeto', () => _aviso(context, 'Projeto acadêmico fan-made. Personagens e valores são usados em uma simulação fictícia.')),
      ]),
    );
  }

  Widget _opcao(IconData icone, String texto, VoidCallback acao) {
    return ListTile(contentPadding: EdgeInsets.zero, leading: Icon(icone, color: AppTheme.amarelo), title: Text(texto, style: const TextStyle(color: Colors.white70, fontSize: 13)), trailing: const Icon(Icons.chevron_right, color: Colors.white30), onTap: acao);
  }

  void _aviso(BuildContext context, String texto) {
    showDialog(context: context, builder: (_) => AlertDialog(backgroundColor: AppTheme.painel, content: Text(texto, style: const TextStyle(color: Colors.white70)), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('FECHAR'))]));
  }
}

class _PerfilNumero extends StatelessWidget {
  final String valor;
  final String rotulo;
  const _PerfilNumero({required this.valor, required this.rotulo});
  @override
  Widget build(BuildContext context) => Column(children: [Text(valor, style: const TextStyle(color: AppTheme.amarelo, fontWeight: FontWeight.bold, fontSize: 19)), const SizedBox(height: 4), Text(rotulo, style: const TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 1))]);
}
