import 'package:flutter/material.dart';
import '../models/contrato.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class ContratosScreen extends StatefulWidget {
  const ContratosScreen({super.key});

  @override
  State<ContratosScreen> createState() => _ContratosScreenState();
}

class _ContratosScreenState extends State<ContratosScreen> {
  late Future<List<Contrato>> future;
  String dificuldade = 'Todas';

  @override
  void initState() {
    super.initState();
    future = ApiService.buscarContratos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GIGS DISPONÍVEIS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.3))),
      body: FutureBuilder<List<Contrato>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: AppTheme.amarelo));
          if (snapshot.hasError) return ApiError(mensagem: 'Não foi possível carregar os contratos.', tentarNovamente: () {
            setState(() {
              future = ApiService.buscarContratos();
            });
          });
          final lista = (snapshot.data ?? []).where((item) => dificuldade == 'Todas' || item.dificuldade == dificuldade).toList();

          return Column(children: [
            SizedBox(
              height: 54,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                scrollDirection: Axis.horizontal,
                children: ['Todas', 'Baixa', 'Média', 'Alta', 'Extrema'].map((item) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(item), selected: dificuldade == item,
                    onSelected: (_) => setState(() => dificuldade = item),
                    selectedColor: AppTheme.amarelo, backgroundColor: AppTheme.painel,
                    labelStyle: TextStyle(color: dificuldade == item ? Colors.black : Colors.white70, fontSize: 11), side: BorderSide.none,
                  ),
                )).toList(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                itemCount: lista.length,
                itemBuilder: (context, index) => ContratoCard(
                  contrato: lista[index],
                  onTap: () => showModalBottomSheet(
                    context: context,
                    backgroundColor: AppTheme.painel,
                    showDragHandle: true,
                    builder: (_) => Padding(
                      padding: const EdgeInsets.fromLTRB(22, 8, 22, 30),
                      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(lista[index].titulo, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 10),
                        Text('${lista[index].categoria} • ${lista[index].distrito} • ${lista[index].dificuldade}', style: const TextStyle(color: AppTheme.amarelo, fontSize: 11)),
                        const SizedBox(height: 16),
                        Text(lista[index].descricao, style: const TextStyle(color: Colors.white70, height: 1.5)),
                        const SizedBox(height: 18),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('RECOMPENSA DO CONTRATO', style: TextStyle(color: Colors.white54, fontSize: 10)), Text(dinheiro(lista[index].recompensa), style: const TextStyle(color: AppTheme.amarelo, fontSize: 17, fontWeight: FontWeight.bold))]),
                        const SizedBox(height: 8),
                        Text('Prazo estimado: ${lista[index].prazo}', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}
