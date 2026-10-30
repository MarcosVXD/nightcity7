import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NightCityEddiesApp());
}

class NightCityEddiesApp extends StatelessWidget {
  const NightCityEddiesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Night City Eddies',
      theme: AppTheme.tema,
      home: const SplashScreen(),
    );
  }
}
