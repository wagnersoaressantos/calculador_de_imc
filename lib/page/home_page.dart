import 'package:calculadora_imc/page/calcular_imc_page.dart';
import 'package:calculadora_imc/page/historico_imc_page.dart';
import 'package:calculadora_imc/share/imagens_share.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Calculadora de IMC'), centerTitle: true),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CalcularImcPage(),
                          ),
                        );
                      },

                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Expanded(child: Image.asset(ImagensShare.imc)),
                              Text('Calculadora de IMC'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoricoImcPage(),
                          ),
                        );
                      },

                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Expanded(child: Image.asset(ImagensShare.imc)),
                              Text('Lista de IMC'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(flex: 3, child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
