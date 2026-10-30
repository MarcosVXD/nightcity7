import 'package:flutter/material.dart';
import '../models/mercenario.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class MercenariosScreen extends StatefulWidget {
  final Set<int> favoritos;
  final void Function(int) aoFavoritar;
  final void Function(Mercenario) aoAbrir;

  const MercenariosScreen({super.key, required this.favoritos, required this.aoFavoritar, required this.aoAbrir});

  @override
  State<MercenariosScreen> createState() => _MercenariosScreenState();
}

class _MercenariosScreenState extends State<MercenariosScreen> {
  late Future<List<Mercenario>> future;
  String busca = '';
  String filtro = 'Todos';
  final filtros = ['Todos', 'Combate', 'Infiltração', 'Tecnologia', 'Planejamento'];

  @override
  void initState() {
    super.initState();
    future = ApiService.buscarMercenarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MERCENÁRIOS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5))),
      body: FutureBuilder<List<Mercenario>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: AppTheme.amarelo));
          if (snapshot.hasError) return ApiError(mensagem: 'A API não respondeu. Verifique o servidor.', tentarNovamente: () {
            setState(() {
              future = ApiService.buscarMercenarios();
            });
          });

          final lista = (snapshot.data ?? []).where((item) {
            final texto = '${item.nome} ${item.especialidade} ${item.distrito}'.toLowerCase();
            final combinaBusca = texto.contains(busca.toLowerCase());
            final combinaFiltro = filtro == 'Todos' || item.especialidade.toLowerCase().contains(filtro.toLowerCase());
            return combinaBusca && combinaFiltro;
          }).toList();

          return Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
              child: TextField(
                onChanged: (valor) => setState(() => busca = valor),
                decoration: const InputDecoration(hintText: 'Buscar nome, habilidade ou distrito', prefixIcon: Icon(Icons.search)),
              ),
            ),
            SizedBox(
              height: 42,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: filtros.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final item = filtros[index];
                  return ChoiceChip(
                    label: Text(item),
                    selected: filtro == item,
                    onSelected: (_) => setState(() => filtro = item),
                    selectedColor: AppTheme.amarelo,
                    backgroundColor: AppTheme.painel,
                    labelStyle: TextStyle(color: filtro == item ? Colors.black : Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                    side: BorderSide.none,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('OPERADORES ENCONTRADOS', style: TextStyle(color: AppTheme.amarelo, fontSize: 10, letterSpacing: 1.3)), Text('${lista.length} PERFIS', style: const TextStyle(color: Colors.white38, fontSize: 10))]),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: lista.isEmpty
                  ? const Center(child: Text('Nenhum mercenário encontrado.', style: TextStyle(color: Colors.white54)))
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      itemCount: lista.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.68),
                      itemBuilder: (context, index) {
                        final item = lista[index];
                        return MercenarioCard(
                          mercenario: item,
                          favorito: widget.favoritos.contains(item.id),
                          abrir: () => widget.aoAbrir(item),
                          alternarFavorito: () => widget.aoFavoritar(item.id),
                        );
                      },
                    ),
            ),
          ]);
        },
      ),
    );
  }
}
