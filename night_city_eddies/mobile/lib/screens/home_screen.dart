import 'package:flutter/material.dart';
import '../models/mercenario.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class HomeScreen extends StatefulWidget {
  final Set<int> favoritos;
  final void Function(int) aoFavoritar;
  final void Function(Mercenario) aoAbrir;
  final VoidCallback irParaCatalogo;

  const HomeScreen({super.key, required this.favoritos, required this.aoFavoritar, required this.aoAbrir, required this.irParaCatalogo});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Mercenario>> future;

  @override
  void initState() {
    super.initState();
    future = ApiService.buscarMercenarios();
  }

  void recarregar() {
    setState(() {
      future = ApiService.buscarMercenarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [Icon(Icons.bolt, color: AppTheme.amarelo), SizedBox(width: 8), Text('NIGHT CITY', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2))]),
        actions: [IconButton(onPressed: widget.irParaCatalogo, icon: const Icon(Icons.search)), IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none))],
      ),
      body: FutureBuilder<List<Mercenario>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: AppTheme.amarelo));
          if (snapshot.hasError) return ApiError(mensagem: 'Não foi possível acessar a API. Confira se o servidor Node.js está ligado.', tentarNovamente: recarregar);
          final lista = snapshot.data ?? [];
          final destaques = lista.where((item) => item.destaque).toList();

          return RefreshIndicator(
            color: AppTheme.amarelo,
            onRefresh: () async => recarregar(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
              children: [
                Container(
                  height: 190,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(colors: [Color(0xFF393510), Color(0xFF191919), Color(0xFF17191D)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    border: Border.all(color: AppTheme.amarelo.withOpacity(0.45)),
                  ),
                  child: Stack(
                    children: [
                      Positioned(right: -12, bottom: -28, child: Icon(Icons.bolt, size: 160, color: AppTheme.amarelo.withOpacity(0.12))),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('A CIDADE NÃO ESPERA.', style: TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 2)),
                        const SizedBox(height: 12),
                        const Text('Precisa de um\ntrabalho feito?', style: TextStyle(color: Colors.white, fontSize: 27, height: 1.05, fontWeight: FontWeight.w900)),
                        const Spacer(),
                        ElevatedButton(onPressed: widget.irParaCatalogo, child: const Text('ENCONTRAR MERCENÁRIO')),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const SectionTitle('Categorias de serviço'),
                const SizedBox(height: 12),
                Row(children: [
                  _categoria(Icons.gps_fixed, 'Combate'),
                  const SizedBox(width: 8),
                  _categoria(Icons.visibility_off_outlined, 'Infiltração'),
                  const SizedBox(width: 8),
                  _categoria(Icons.memory, 'Tecnologia'),
                ]),
                const SizedBox(height: 25),
                SectionTitle('Mercenários em destaque', acao: 'Ver todos', onTap: widget.irParaCatalogo),
                const SizedBox(height: 12),
                if (destaques.isEmpty)
                  const Text('Nenhum destaque disponível.', style: TextStyle(color: Colors.white54))
                else
                  SizedBox(
                    height: 285,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: destaques.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final item = destaques[index];
                        return SizedBox(
                          width: 190,
                          child: MercenarioCard(
                            mercenario: item,
                            favorito: widget.favoritos.contains(item.id),
                            abrir: () => widget.aoAbrir(item),
                            alternarFavorito: () => widget.aoFavoritar(item.id),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 25),
                const SectionTitle('Central de operações'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: AppTheme.painel, borderRadius: BorderRadius.circular(13)),
                  child: const Row(children: [Icon(Icons.radar, color: AppTheme.amarelo, size: 34), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('REDE DE FIXERS ATIVA', style: TextStyle(color: AppTheme.amarelo, fontWeight: FontWeight.bold, fontSize: 12)), SizedBox(height: 4), Text('Novos trabalhos disponíveis em vários distritos de Night City.', style: TextStyle(color: Colors.white60, fontSize: 11))]))]),
                ),
                const SizedBox(height: 12),
                const Text('FAN-MADE MARKETPLACE // CONTRATOS E VALORES FICTÍCIOS', textAlign: TextAlign.center, style: TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 1)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _categoria(IconData icone, String texto) {
    return Expanded(
      child: GestureDetector(
        onTap: widget.irParaCatalogo,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 6),
          decoration: BoxDecoration(color: AppTheme.painel, borderRadius: BorderRadius.circular(11), border: Border.all(color: const Color(0xFF303238))),
          child: Column(children: [Icon(icone, color: AppTheme.amarelo, size: 23), const SizedBox(height: 7), Text(texto, style: const TextStyle(color: Colors.white70, fontSize: 10))]),
        ),
      ),
    );
  }
}
