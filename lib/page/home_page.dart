import 'package:calculadora_imc/page/atividade_page.dart';
import 'package:calculadora_imc/page/calcular_imc_page.dart';
import 'package:calculadora_imc/page/historico_imc_page.dart';
import 'package:calculadora_imc/share/imagens_share.dart';
import 'package:calculadora_imc/share/widget/custon_drawer.dart';
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
        appBar: AppBar(
          title: const Text('Calculadora de IMC'),
          centerTitle: true,
        ),
        drawer: const CustonDrawer(),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Substituímos a Row pelo Wrap envolto num Container de largura total
              SizedBox(
                width:
                    double
                        .infinity, // Diz ao Wrap para usar toda a largura da tela
                child: Wrap(
                  alignment:
                      WrapAlignment.center, // Centraliza os cartões na tela
                  spacing: 16.0, // Espaçamento horizontal entre os cartões
                  runSpacing:
                      16.0, // Espaçamento vertical (quando um cartão cai para a linha de baixo)
                  children: [
                    // 1º Cartão com tamanho fixo
                    SizedBox(
                      width: 100, // Largura fixa do cartão
                      height: 120, // Altura fixa do cartão
                      child: GestureDetector(
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
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: Image.asset(ImagensShare.imc)),
                                const SizedBox(height: 8),
                                const Text(
                                  'Calculadora',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 2º Cartão com tamanho fixo
                    SizedBox(
                      width: 100,
                      height: 120,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HistoricoImcPage(),
                            ),
                          );
                        },
                        child: Card(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: Image.asset(ImagensShare.imc)),
                                const SizedBox(height: 8),
                                const Text(
                                  'Lista de IMC',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 3º Cartão com tamanho fixo
                    SizedBox(
                      width: 100,
                      height: 120,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AtividadePage(),
                            ),
                          );
                        },
                        child: Card(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: Image.asset(ImagensShare.imc)),
                                const SizedBox(height: 8),
                                const Text(
                                  'Atividades',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Experimente adicionar um 4º cartão aqui depois para ver a magia acontecer!
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
