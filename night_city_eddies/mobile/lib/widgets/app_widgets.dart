import 'package:flutter/material.dart';
import '../models/mercenario.dart';
import '../models/contrato.dart';
import '../theme/app_theme.dart';

String dinheiro(int valor) => '€\$ ${valor.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    )}';

class SectionTitle extends StatelessWidget {
  final String titulo;
  final String? acao;
  final VoidCallback? onTap;

  const SectionTitle(this.titulo, {super.key, this.acao, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          titulo.toUpperCase(),
          style: const TextStyle(
            color: AppTheme.amarelo,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        if (acao != null)
          TextButton(onPressed: onTap, child: Text(acao!)),
      ],
    );
  }
}

class ApiError extends StatelessWidget {
  final String mensagem;
  final VoidCallback tentarNovamente;

  const ApiError({super.key, required this.mensagem, required this.tentarNovamente});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.signal_wifi_connected_no_internet_4, color: AppTheme.vermelho, size: 46),
            const SizedBox(height: 14),
            const Text('CONEXÃO INTERROMPIDA', style: TextStyle(color: AppTheme.amarelo, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const SizedBox(height: 8),
            Text(mensagem, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white60)),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: tentarNovamente,
              icon: const Icon(Icons.refresh),
              label: const Text('TENTAR NOVAMENTE'),
            ),
          ],
        ),
      ),
    );
  }
}

class MercenarioCard extends StatelessWidget {
  final Mercenario mercenario;
  final bool favorito;
  final VoidCallback abrir;
  final VoidCallback alternarFavorito;

  const MercenarioCard({
    super.key,
    required this.mercenario,
    required this.favorito,
    required this.abrir,
    required this.alternarFavorito,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: abrir,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.painel,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFF303238)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: const Color(0xFF202228)),
                  Image.network(
                    mercenario.imagem,
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.person, color: AppTheme.amarelo, size: 65),
                    ),
                  ),
                  Positioned(
                    top: 7,
                    right: 7,
                    child: IconButton.filled(
                      onPressed: alternarFavorito,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.65),
                        foregroundColor: favorito ? AppTheme.amarelo : Colors.white,
                      ),
                      icon: Icon(favorito ? Icons.bookmark : Icons.bookmark_border, size: 19),
                    ),
                  ),
                  Positioned(
                    left: 9,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      color: AppTheme.amarelo,
                      child: Text(
                        mercenario.disponibilidade.toUpperCase(),
                        style: const TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(11, 10, 11, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(mercenario.nome, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(mercenario.especialidade, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white54, fontSize: 10)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [const Icon(Icons.star, size: 13, color: AppTheme.amarelo), const SizedBox(width: 3), Text(mercenario.reputacao.toStringAsFixed(1), style: const TextStyle(fontSize: 11, color: Colors.white70))]),
                      Text(dinheiro(mercenario.valor), style: const TextStyle(color: AppTheme.amarelo, fontWeight: FontWeight.bold, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContratoCard extends StatelessWidget {
  final Contrato contrato;
  final VoidCallback? onTap;

  const ContratoCard({super.key, required this.contrato, this.onTap});

  @override
  Widget build(BuildContext context) {
    Color cor = contrato.dificuldade == 'Extrema'
        ? AppTheme.vermelho
        : contrato.dificuldade == 'Alta'
            ? Colors.orangeAccent
            : AppTheme.amarelo;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppTheme.painel,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xFF303238)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(contrato.titulo, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(color: cor.withOpacity(0.12), borderRadius: BorderRadius.circular(5)),
                  child: Text(contrato.dificuldade.toUpperCase(), style: TextStyle(color: cor, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('${contrato.categoria}  •  ${contrato.distrito}', style: const TextStyle(color: Colors.white54, fontSize: 11)),
            const SizedBox(height: 12),
            Text(contrato.descricao, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, height: 1.4, fontSize: 12)),
            const SizedBox(height: 13),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [const Icon(Icons.timer_outlined, color: Colors.white54, size: 15), const SizedBox(width: 5), Text(contrato.prazo, style: const TextStyle(color: Colors.white54, fontSize: 11))]),
                Text(dinheiro(contrato.recompensa), style: const TextStyle(color: AppTheme.amarelo, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
