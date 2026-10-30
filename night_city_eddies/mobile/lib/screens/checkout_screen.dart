import 'package:flutter/material.dart';
import '../models/contrato.dart';
import '../models/mercenario.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class CheckoutScreen extends StatefulWidget {
  final Mercenario mercenario;
  const CheckoutScreen({super.key, required this.mercenario});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late Future<List<Contrato>> future;
  int? contratoSelecionado;
  bool enviando = false;

  @override
  void initState() {
    super.initState();
    future = ApiService.buscarContratos();
  }

  Future<void> confirmar(List<Contrato> contratos) async {
    if (contratoSelecionado == null) return;
    setState(() => enviando = true);
    try {
      await ApiService.contratar(widget.mercenario.id, contratoSelecionado!);
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: AppTheme.painel,
          icon: const Icon(Icons.check_circle, color: AppTheme.amarelo, size: 45),
          title: const Text('CONTRATO ENVIADO'),
          content: const Text('Sua solicitação foi registrada na rede de fixers.', style: TextStyle(color: Colors.white70)),
          actions: [TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('ENTENDIDO'))],
        ),
      );
    } catch (erro) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$erro')));
    } finally {
      if (mounted) setState(() => enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CONFIRMAR CONTRATO', style: TextStyle(fontSize: 13, letterSpacing: 1.2))),
      body: FutureBuilder<List<Contrato>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: AppTheme.amarelo));
          if (snapshot.hasError) return ApiError(mensagem: 'Não foi possível carregar os contratos disponíveis.', tentarNovamente: () {
            setState(() {
              future = ApiService.buscarContratos();
            });
          });
          final contratos = snapshot.data ?? [];
          Contrato? selecionado;
          for (final item in contratos) {
            if (item.id == contratoSelecionado) {
              selecionado = item;
              break;
            }
          }
          final total = widget.mercenario.valor + (selecionado?.recompensa ?? 0);

          return Column(children: [
            Expanded(
              child: ListView(padding: const EdgeInsets.all(18), children: [
                const Text('OPERADOR SELECIONADO', style: TextStyle(color: AppTheme.amarelo, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Container(padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: AppTheme.painel, borderRadius: BorderRadius.circular(12)), child: Row(children: [ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(widget.mercenario.imagem, width: 58, height: 65, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox(width: 58, height: 65, child: Icon(Icons.person, color: AppTheme.amarelo)))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.mercenario.nome, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(widget.mercenario.especialidade, style: const TextStyle(color: Colors.white54, fontSize: 11))])), Text(dinheiro(widget.mercenario.valor), style: const TextStyle(color: AppTheme.amarelo, fontWeight: FontWeight.bold, fontSize: 12))])),
                const SizedBox(height: 25),
                const Text('ESCOLHA O TRABALHO', style: TextStyle(color: AppTheme.amarelo, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                const SizedBox(height: 9),
                ...contratos.map((contrato) => Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  decoration: BoxDecoration(color: AppTheme.painel, borderRadius: BorderRadius.circular(10), border: Border.all(color: contratoSelecionado == contrato.id ? AppTheme.amarelo : const Color(0xFF303238))),
                  child: RadioListTile<int>(
                    value: contrato.id,
                    groupValue: contratoSelecionado,
                    activeColor: AppTheme.amarelo,
                    onChanged: (valor) => setState(() => contratoSelecionado = valor),
                    title: Text(contrato.titulo, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: Text('${contrato.distrito} • ${contrato.dificuldade}\nRecompensa: ${dinheiro(contrato.recompensa)}', style: const TextStyle(color: Colors.white54, fontSize: 10, height: 1.5)),
                  ),
                )),
                const SizedBox(height: 12),
                const Text('Os valores são fictícios e servem apenas para demonstrar o fluxo de contratação.', style: TextStyle(color: Colors.white30, fontSize: 10)),
              ]),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
              decoration: const BoxDecoration(color: AppTheme.painel, border: Border(top: BorderSide(color: Color(0xFF303238)))),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('TAXA DO OPERADOR', style: TextStyle(color: Colors.white54, fontSize: 11)), Text(dinheiro(widget.mercenario.valor), style: const TextStyle(color: Colors.white, fontSize: 12))]),
                const SizedBox(height: 7),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('VALOR DO CONTRATO', style: TextStyle(color: Colors.white54, fontSize: 11)), Text(dinheiro(selecionado?.recompensa ?? 0), style: const TextStyle(color: Colors.white, fontSize: 12))]),
                const Divider(height: 22, color: Color(0xFF393B40)),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('TOTAL SIMULADO', style: TextStyle(color: AppTheme.amarelo, fontWeight: FontWeight.bold, letterSpacing: 1)), Text(dinheiro(total), style: const TextStyle(color: AppTheme.amarelo, fontSize: 20, fontWeight: FontWeight.w900))]),
                const SizedBox(height: 13),
                SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: contratoSelecionado == null || enviando ? null : () => confirmar(contratos), icon: enviando ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send), label: Text(enviando ? 'ENVIANDO...' : 'ENVIAR SOLICITAÇÃO'))),
              ]),
            ),
          ]);
        },
      ),
    );
  }
}
