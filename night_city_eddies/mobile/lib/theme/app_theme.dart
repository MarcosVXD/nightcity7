import 'package:flutter/material.dart';

class AppTheme {
  static const amarelo = Color(0xFFFCEE0A);
  static const fundo = Color(0xFF090A0C);
  static const painel = Color(0xFF17191D);
  static const vermelho = Color(0xFFFF375F);

  static ThemeData tema = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: fundo,
    colorScheme: const ColorScheme.dark(
      primary: amarelo,
      secondary: vermelho,
      surface: painel,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: fundo,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: painel,
      indicatorColor: amarelo.withOpacity(0.16),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: painel,
      hintStyle: const TextStyle(color: Colors.white38),
      prefixIconColor: amarelo,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF303238)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: amarelo),
      ),
    ),
  );
}
