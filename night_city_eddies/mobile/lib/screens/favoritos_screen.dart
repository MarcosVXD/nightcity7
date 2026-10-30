import 'package:flutter/material.dart';
import '../models/mercenario.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class FavoritosScreen extends StatefulWidget {
  final Set<int> favoritos;
  final void Function(Mercenario) aoAbrir;
  final void Function(int) aoFavoritar;

  const FavoritosScreen({super.key, required this.favoritos, required this.aoAbrir, required this.aoFavoritar});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  late Future<List<Mercenario>> future;

  @override
  void initState() {
    super.initState();
    future = ApiService.buscarMercenarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAVORITOS')),
      body: FutureBuilder<List<Mercenario>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: AppTheme.amarelo));
          if (snapshot.hasError) return ApiError(mensagem: 'Não foi possível carregar os favoritos.', tentarNovamente: () {
            setState(() {
              future = ApiService.buscarMercenarios();
            });
          });
          final lista = (snapshot.data ?? []).where((item) => widget.favoritos.contains(item.id)).toList();
          if (lista.isEmpty) return const Center(child: Text('Você ainda não salvou nenhum mercenário.', style: TextStyle(color: Colors.white54)));
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lista.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.68),
            itemBuilder: (context, index) {
              final item = lista[index];
              return MercenarioCard(mercenario: item, favorito: true, abrir: () => widget.aoAbrir(item), alternarFavorito: () { widget.aoFavoritar(item.id); setState(() {}); });
            },
          );
        },
      ),
    );
  }
}
