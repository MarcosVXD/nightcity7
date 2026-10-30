import 'package:flutter/material.dart';
import '../models/mercenario.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'mercenarios_screen.dart';
import 'contratos_screen.dart';
import 'contratacoes_screen.dart';
import 'perfil_screen.dart';
import 'favoritos_screen.dart';
import 'mercenario_detalhe_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int indice = 0;
  final Set<int> favoritos = {};

  void alternarFavorito(int id) {
    setState(() {
      if (!favoritos.add(id)) favoritos.remove(id);
    });
  }

  void abrirMercenario(Mercenario item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MercenarioDetalheScreen(mercenario: item)),
    );
  }

  void abrirFavoritos() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FavoritosScreen(
          favoritos: favoritos,
          aoAbrir: abrirMercenario,
          aoFavoritar: alternarFavorito,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final telas = [
      HomeScreen(
        favoritos: favoritos,
        aoFavoritar: alternarFavorito,
        aoAbrir: abrirMercenario,
        irParaCatalogo: () => setState(() => indice = 1),
      ),
      MercenariosScreen(
        favoritos: favoritos,
        aoFavoritar: alternarFavorito,
        aoAbrir: abrirMercenario,
      ),
      const ContratosScreen(),
      const ContratacoesScreen(),
      PerfilScreen(abrirFavoritos: abrirFavoritos),
    ];

    return Scaffold(
      body: IndexedStack(index: indice, children: telas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: indice,
        onDestinationSelected: (novoIndice) => setState(() => indice = novoIndice),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Início'),
          NavigationDestination(icon: Icon(Icons.person_search_outlined), selectedIcon: Icon(Icons.person_search), label: 'Mercs'),
          NavigationDestination(icon: Icon(Icons.assignment_outlined), selectedIcon: Icon(Icons.assignment), label: 'Gigs'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Pedidos'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
