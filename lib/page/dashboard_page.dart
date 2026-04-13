import 'dart:math';

import 'package:calculadora_imc/model/pessoa_model.dart';
import 'package:calculadora_imc/model/registro_imc_model.dart';
import 'package:calculadora_imc/repository/pessoa_repository.dart';
import 'package:calculadora_imc/service/atividade_analise_service.dart';
import 'package:calculadora_imc/service/imc_analise_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final PessoaRepository _repo = PessoaRepository();
  final _analise = ImcAnaliseService();
  final _atividadeAnalise = AtividadeAnaliseService();

  List<PessoaModel> _pessoas = [];
  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    _pessoas = _repo.listarPessoas();
  }

  // 🔹 Converte registros em pontos para o gráfico
  List<FlSpot> _gerarPontos(PessoaModel pessoa) {
    List<FlSpot> pontos = [];

    for (int i = 0; i < pessoa.registros.length; i++) {
      final registro = pessoa.registros[i];

      // eixo X = índice (tempo simplificado)
      // eixo Y = valor do IMC
      pontos.add(FlSpot(i.toDouble(), registro.imc));
    }
    return pontos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard IMC')),
      body:
          _pessoas.isEmpty
              ? Center(child: Text("Sem dados para exibir"))
              : ListView.builder(
                itemCount: _pessoas.length,
                itemBuilder: (context, index) {
                  final pessoa = _pessoas[index];
                  return Card(
                    margin: const EdgeInsets.all(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                pessoa.nome,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // 🔥 GRÁFICO
                          SizedBox(
                            height: 200,
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(show: true),

                                // titlesData: FlTitlesData(
                                //   leftTitles: AxisTitles(
                                //     sideTitles: SideTitles(showTitles: true),
                                //   ),
                                //   bottomTitles: AxisTitles(
                                //     sideTitles: SideTitles(showTitles: true),
                                //   ),
                                // ),
                                borderData: FlBorderData(show: false),

                                lineBarsData: [
                                  LineChartBarData(
                                    spots: _gerarPontos(pessoa),

                                    isCurved: true,
                                    color: Colors.blue,

                                    dotData: FlDotData(show: true),

                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: Colors.blue.withValues(
                                        blue: 0.2,
                                      ), // 🔥 área preenchida
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _infoBox(
                                "Média",
                                _analise
                                    .calcularMedia(pessoa.registros)
                                    .toStringAsFixed(2),
                                Icons.analytics,
                              ),

                              _infoBox(
                                "Tendência",
                                _analise.calcularTendencia(pessoa.registros),
                                Icons.trending_up,
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          // Text(_analise.preverMeta(pessoa.registros)),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.psychology,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _analise.preverMeta(pessoa.registros),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.lightbulb,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _atividadeAnalise.gerarInsightCompleto(
                                      pessoa,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      // body: SafeArea(
      //   child:
      //       pessoa == null
      //           ? const _DashboardEmptyState(
      //             message: 'Nenhum usuário encontrado',
      //           )
      //           : _registrosOrdenados.isEmpty
      //           ? const _DashboardEmptyState(
      //             message: 'Nenhum registro de IMC para exibir',
      //           )
      //           : RefreshIndicator(
      //             onRefresh: () async {
      //               _carregarDados();
      //             },
      //             child: ListView(
      //               padding: const EdgeInsets.all(16),
      //               children: [
      //                 _DashboardHeader(
      //                   nome: pessoa.nome,
      //                   totalRegistros: _registrosOrdenados.length,
      //                   ultimoImc: _registrosOrdenados.last.imc,
      //                 ),
      //                 const SizedBox(height: 16),
      //                 _DashboardChartCard(registros: _registrosOrdenados),
      //                 const SizedBox(height: 16),
      //                 _RecentRecordsCard(registros: _registrosOrdenados),
      //               ],
      //             ),
      //           ),
      // ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.nome,
    required this.totalRegistros,
    required this.ultimoImc,
  });

  final String nome;
  final int totalRegistros;
  final double ultimoImc;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nome, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Total de registros: $totalRegistros'),
            Text('Último IMC: ${ultimoImc.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}

class _DashboardChartCard extends StatelessWidget {
  const _DashboardChartCard({required this.registros});

  final List<RegistroImcModel> registros;

  @override
  Widget build(BuildContext context) {
    // Prepara os pontos com X sequencial e Y igual ao valor de IMC.
    final spots =
        registros.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.imc);
        }).toList();

    final minY = registros.map((registro) => registro.imc).reduce(min);
    final maxY = registros.map((registro) => registro.imc).reduce(max);
    final maxX = max(1.0, (spots.length - 1).toDouble());
    final verticalPadding = max(1.0, (maxY - minY) * 0.15);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Evolução do IMC',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 280,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: maxX,
                  minY: minY - verticalPadding,
                  maxY: maxY + verticalPadding,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _calculateInterval(minY, maxY),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        interval: _calculateInterval(minY, maxY),
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(value.toStringAsFixed(1)),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 34,
                        interval: _bottomInterval(registros.length),
                        // Mostra a data resumida para não poluir o eixo X.
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= registros.length) {
                            return const SizedBox.shrink();
                          }

                          return SideTitleWidget(
                            meta: meta,
                            space: 8,
                            child: Text(_formatDate(registros[index].data)),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: false,
                      barWidth: 3,
                      color: Theme.of(context).colorScheme.primary,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static double _calculateInterval(double minY, double maxY) {
    final difference = maxY - minY;
    if (difference <= 2) {
      return 0.5;
    }
    if (difference <= 5) {
      return 1;
    }
    return 2;
  }

  static double _bottomInterval(int totalRegistros) {
    if (totalRegistros <= 4) {
      return 1;
    }
    if (totalRegistros <= 8) {
      return 2;
    }
    return (totalRegistros / 4).ceilToDouble();
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month';
  }
}

class _RecentRecordsCard extends StatelessWidget {
  const _RecentRecordsCard({required this.registros});

  final List<RegistroImcModel> registros;

  @override
  Widget build(BuildContext context) {
    final ultimosRegistros = registros.reversed.take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Últimos registros',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...ultimosRegistros.map((registro) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.monitor_weight_outlined),
                title: Text('IMC ${registro.imc.toStringAsFixed(2)}'),
                subtitle: Text(
                  'Peso ${registro.peso.toStringAsFixed(1)} kg • ${_DashboardChartCard._formatDate(registro.data)}',
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _DashboardEmptyState extends StatelessWidget {
  const _DashboardEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    // Trata os cenários sem dados sem quebrar a navegação da tela.
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.insert_chart_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _infoBox(String titulo, String valor, IconData icone) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, color: Colors.blue),
          const SizedBox(height: 5),
          Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),

          // 🔥 CORREÇÃO PRINCIPAL
          Text(
            valor,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    ),
  );
}
