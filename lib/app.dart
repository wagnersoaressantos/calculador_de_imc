import 'package:calculadora_imc/page/home_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora de IMC',

      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromRGBO(4, 238, 82, 1),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.cyan,
          accentColor: Colors.cyan,
        ),
      ),
      home: const HomePage(), // Substitua por sua página inicial
    );
  }
}
