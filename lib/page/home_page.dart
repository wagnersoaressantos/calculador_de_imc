import 'package:calculadora_imc/page/calcular_imc_page.dart';
import 'package:calculadora_imc/page/historico_atividade_page.dart';
import 'package:calculadora_imc/page/historico_imc_page.dart';
import 'package:calculadora_imc/page/dashboard_page.dart';
import 'package:calculadora_imc/share/widget/custon_drawer.dart';
import 'package:flutter/material.dart';

import 'package:calculadora_imc/model/pessoa_model.dart';
import 'package:calculadora_imc/repository/pessoa_repository.dart';
import 'package:calculadora_imc/service_locator.dart';
import 'package:calculadora_imc/calcularIMC/calculador_de_imc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _repo = getIt<PessoaRepository>();
  PessoaModel? _usuarioPrincipal;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    final pessoas = _repo.listarPessoas();
    setState(() {
      if (pessoas.isNotEmpty) {
        _usuarioPrincipal = pessoas.first;
      }
    });
  }

  Widget _construirPainelResumo() {
    if (_usuarioPrincipal == null) {
      return const Center(
        child: Text(
          "Bem-vindo! Cadastre um IMC para ver o seu resumo aqui.",
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      );
    }

    final pessoa = _usuarioPrincipal!;
    double ultimoImc = 0.0;
    String classificacao = "Sem dados";
    double caloriasTotais = 0.0;

    if (pessoa.registros.isNotEmpty) {
      ultimoImc = pessoa.registros.last.imc;
      classificacao = CalculadorDeImc.classificacaoIMC(ultimoImc);
    }

    for (var atividade in pessoa.atividades) {
      caloriasTotais += atividade.caloriasGastas ?? 0.0;
    }

    return Card(
      elevation: 4,
      // 🔥 CORREÇÃO: Removemos o 'color: Colors.white'. O Flutter agora escolhe a cor do cartão baseado no Tema (Claro/Escuro)
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Olá, ${pessoa.nome}! 👋",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 30, thickness: 1),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.monitor_weight, color: Colors.white),
              ),
              title: const Text("Último IMC Registado"),
              subtitle: Text(
                ultimoImc > 0
                    ? "${ultimoImc.toStringAsFixed(1)} - $classificacao"
                    : "Nenhum registo",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: Colors.orange,
                child: Icon(Icons.local_fire_department, color: Colors.white),
              ),
              title: const Text("Total de Calorias Queimadas"),
              subtitle: Text(
                "${caloriasTotais.toStringAsFixed(0)} kcal",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Saúde & IMC'),
          centerTitle: true,
          elevation: 0,
        ),
        drawer: const CustonDrawer(),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16.0,
                    runSpacing: 16.0,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 16.0,
                          runSpacing: 16.0,
                          children: [
                            // 1º Cartão: Calculadora
                            SizedBox(
                              width: 100,
                              height: 120,
                              child: GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const CalcularImcPage(),
                                    ),
                                  );
                                  _carregarDados();
                                },
                                child: Card(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // 🔥 Mudámos de Image.asset para Icon
                                        Expanded(
                                          child: Icon(
                                            Icons.calculate,
                                            size: 40,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Calculadora',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // 2º Cartão: Lista de IMC
                            SizedBox(
                              width: 100,
                              height: 120,
                              child: GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const HistoricoImcPage(),
                                    ),
                                  );
                                  _carregarDados();
                                },
                                child: Card(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // 🔥 Ícone de Histórico / Lista
                                        Expanded(
                                          child: Icon(
                                            Icons.history,
                                            size: 40,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Lista de IMC',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // 3º Cartão: Atividades
                            SizedBox(
                              width: 100,
                              height: 120,
                              child: GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              const HistoricoAtividadePage(),
                                    ),
                                  );
                                  _carregarDados();
                                },
                                child: Card(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // 🔥 Ícone de Corrida / Fitness
                                        Expanded(
                                          child: Icon(
                                            Icons.directions_run,
                                            size: 40,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Atividades',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // 4º Cartão: Dashboard (Já estava perfeito!)
                            SizedBox(
                              width: 100,
                              height: 120,
                              child: GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const DashboardPage(),
                                    ),
                                  );
                                  _carregarDados();
                                },
                                child: Card(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Icon(
                                            Icons.analytics,
                                            size: 40,
                                            color:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Dashboard',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: SingleChildScrollView(child: _construirPainelResumo()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
