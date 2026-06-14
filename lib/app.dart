import 'package:calculadora_imc/page/home_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora de IMC',

      // 🧠 A MAGIA: Pede ao Flutter para seguir a configuração do telemóvel (Claro ou Escuro)
      themeMode: ThemeMode.system,

      // 🌞 TEMA CLARO (Light Mode)
      theme: ThemeData(
        useMaterial3: true, // Usa o design moderno do Android/iOS
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor:
              Colors.grey.shade50, // Um fundo suave para os campos de texto
        ),
      ),

      // 🌙 TEMA ESCURO (Dark Mode)
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor:
              Colors.blue, // Mantém a identidade azul, mas adapta para escuro
          brightness: Brightness.dark,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.grey.shade900,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.grey.shade800, // Cartões mais escuros que o fundo
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade900,
        ),
      ),

      home: const HomePage(),
    );
  }
}
