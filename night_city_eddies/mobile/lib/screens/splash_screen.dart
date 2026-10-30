import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.fundo,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: -75,
            bottom: -35,
            width: 360,
            height: 510,
            child: Opacity(
              opacity: 0.22,
              child: Image.network(
                'https://www.cyberpunk.net/build/images/cyberpunk/character/character-panam%401x-b51d31a7.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, AppTheme.fundo.withOpacity(0.95)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.bolt, color: AppTheme.amarelo, size: 48),
                const SizedBox(height: 20),
                const Text('NIGHT CITY', style: TextStyle(color: AppTheme.amarelo, fontSize: 37, fontWeight: FontWeight.w900, letterSpacing: 2)),
                const Text('EDDIES', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900, letterSpacing: 7)),
                const SizedBox(height: 12),
                const Text('CONTRATE. EXECUTE. SOBREVIVA.', style: TextStyle(color: Colors.white70, letterSpacing: 2, fontSize: 10)),
                const SizedBox(height: 55),
                const SizedBox(width: 190, child: LinearProgressIndicator(color: AppTheme.amarelo, backgroundColor: Color(0xFF303238))),
                const SizedBox(height: 12),
                const Text('CONECTANDO À REDE DE FIXERS...', style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1.5)),
              ],
            ),
          ),
          const Positioned(left: 28, bottom: 24, child: Text('FAN-MADE SIMULATION // 2077', style: TextStyle(color: Colors.white30, fontSize: 9, letterSpacing: 1.5))),
        ],
      ),
    );
  }
}
