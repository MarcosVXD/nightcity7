import 'package:flutter/material.dart';
import '../models/contratacao.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class ContratacoesScreen extends StatefulWidget {
  const ContratacoesScreen({super.key});

  @override
  State<ContratacoesScreen> createState() => _ContratacoesScreenState();
}

class _ContratacoesScreenState extends State<ContratacoesScreen> {
  late Future<List<Contratacao>> future;

  @override
  void initState() {
    super.initState();
    future = ApiService.buscarContratacoes();
  }

  void recarregar() {
    setState(() {
      future = ApiService.buscarContratacoes();
    });
  }

  Future<void> cancelar(int id) async {
    try {
      await ApiService.cancelarContratacao(id);
      recarregar();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contratação cancelada.')));
    } catch (erro) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$erro')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MEUS PEDIDOS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.4)), actions: [IconButton(onPressed: recarregar, icon: const Icon(Icons.refresh))]),
      body: FutureBuilder<List<Contratacao>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: AppTheme.amarelo));
          if (snapshot.hasError) return ApiError(mensagem: 'Não foi possível consultar suas contratações.', tentarNovamente: recarregar);
          final lista = snapshot.data ?? [];
          if (lista.isEmpty) return const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.receipt_long_outlined, size: 55, color: Colors.white24), SizedBox(height: 12), Text('Nenhum contrato solicitado ainda.', style: TextStyle(color: Colors.white54))]));

          return RefreshIndicator(
            color: AppTheme.amarelo,
            onRefresh: () async => recarregar(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final item = lista[index];
                final cancelavel = item.status == 'Solicitado' || item.status == 'Aceito';
                return Container(
                  margin: const EdgeInsets.only(bottom: 13),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppTheme.painel, borderRadius: BorderRadius.circular(13), border: Border.all(color: const Color(0xFF303238))),
                  child: Column(children: [
                    Row(children: [
                      ClipRRect(borderRadius: BorderRadius.circular(9), child: Image.network(item.imagem, width: 65, height: 78, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 65, height: 78, color: Colors.black26, child: const Icon(Icons.person, color: AppTheme.amarelo)))),
                      const SizedBox(width: 13),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.contrato.toUpperCase(), style: const TextStyle(color: AppTheme.amarelo, fontWeight: FontWeight.bold, fontSize: 12)), const SizedBox(height: 6), Text(item.mercenario, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(item.distrito, style: const TextStyle(color: Colors.white54, fontSize: 11))])),
                      Text('#${item.id.toString().padLeft(4, '0')}', style: const TextStyle(color: Colors.white38, fontSize: 10)),
                    ]),
                    const Divider(height: 24, color: Color(0xFF303238)),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(item.status.toUpperCase(), style: TextStyle(color: item.status == 'Cancelado' ? AppTheme.vermelho : AppTheme.amarelo, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)), Text(dinheiro(item.valorTotal), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
                    if (cancelavel) Align(alignment: Alignment.centerRight, child: TextButton.icon(onPressed: () => cancelar(item.id), icon: const Icon(Icons.close, size: 15), label: const Text('CANCELAR PEDIDO'), style: TextButton.styleFrom(foregroundColor: AppTheme.vermelho))),
                  ]),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
