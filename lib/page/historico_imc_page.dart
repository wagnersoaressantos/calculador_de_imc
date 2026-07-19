import 'package:calculadora_imc/calcularIMC/calculador_de_imc.dart';
import 'package:calculadora_imc/model/pessoa_model.dart';
import 'package:calculadora_imc/model/registro_imc_model.dart';
import 'package:calculadora_imc/page/calcular_imc_page.dart';
import 'package:calculadora_imc/repository/pessoa_repository.dart';
import 'package:calculadora_imc/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class HistoricoImcPage extends StatefulWidget {
  const HistoricoImcPage({super.key});

  @override
  State<HistoricoImcPage> createState() => _HistoricoImcPageState();
}

class _HistoricoImcPageState extends State<HistoricoImcPage> {
  final _repo = getIt<PessoaRepository>();
  List<PessoaModel> _listaPessoas = [];

  final _random = Random();

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    _listaPessoas = _repo.listarPessoas();
  }

  Color _corParaNivelIMC(String classificacao) {
    if (classificacao.contains("Abaixo do peso") ||
        classificacao.contains("Magreza"))
      return Colors.blue;
    if (classificacao.contains("Saudável") ||
        classificacao.contains("Peso normal"))
      return Colors.green;
    if (classificacao.contains("Sobrepeso")) return Colors.orange;
    if (classificacao.contains("Obesidade Grau I")) return Colors.deepOrange;
    return Colors.red;
  }

  Widget _construirGraficoEvolucao(List<RegistroImcModel> registros) {
    if (registros.length < 2) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "Adicione mais medições para ver o gráfico de evolução.",
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }
    // 1. Obter todos os valores de IMC para encontrar o mínimo e o máximo
    List<double> valoresImc = registros.map((r) => r.imc).toList();
    double minImc = valoresImc.reduce(min);
    double maxImc = valoresImc.reduce(max);

    // 2. Dar uma folga de 2 pontos (ou pelo menos 1 se a variação for mínima)
    // para que a linha nunca toque no teto ou no chão do gráfico
    double minY = (minImc - 2.0).floorToDouble();
    double maxY = (maxImc + 2.0).ceilToDouble();

    // Se a variação entre o mínimo e o máximo for muito pequena (ex: 24.8 a 25.5),
    // o intervalo de 2.0 que definimos pode ser muito grande.
    // Vamos calcular um intervalo mais inteligente.
    double intervalo = (maxY - minY) > 10 ? 2.0 : 1.0;

    List<FlSpot> pontosDoGrafico =
        registros.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.imc);
        }).toList();

    return Container(
      height: 250, // 🔥 Aumentámos um pouco a altura para os números respirarem
      padding: const EdgeInsets.only(
        right: 20.0,
        left: 10.0,
        top: 24.0,
        bottom: 12.0,
      ),
      child: LineChart(
        LineChartData(
          // 🔥 CORREÇÃO DO TOOLTIP (Balão ao clicar)
          minY: minY,
          maxY: maxY,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor:
                  (LineBarSpot touchedSpot) =>
                      Colors.blueGrey.withOpacity(0.8), // CORRIGIDO AQUI
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  // Formatamos para 1 casa decimal e adicionamos o "IMC" no balão
                  return LineTooltipItem(
                    "IMC: ${spot.y.toStringAsFixed(1)}",
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false, // Tira as linhas em pé
            horizontalInterval: intervalo,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize:
                    40, // 🔥 Dá espaço suficiente para o número não cortar
                interval:
                    2.0, // 🔥 Força a desenhar números apenas a cada 2 pontos de IMC (ex: 22, 24, 26)
                getTitlesWidget: (value, meta) {
                  // 🔥 Formata o número do eixo Y para não ter dezenas de casas decimais
                  return SideTitleWidget(
                    meta: meta, // CORRIGIDO AQUI
                    space: 8.0,
                    child: Text(
                      value.toStringAsFixed(
                        0,
                      ), // Mostra o número inteiro no eixo
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: pontosDoGrafico,
              isCurved: true,
              color: Theme.of(context).primaryColor,
              barWidth:
                  3, // 🔥 Linha ligeiramente mais fina para ficar elegante
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context).primaryColor.withOpacity(0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Histórico de IMC")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CalcularImcPage()),
          );
          setState(() {
            _carregarDados();
          });
        },
      ),
      body:
          _listaPessoas.isEmpty
              ? const Center(child: Text("Nenhum histórico encontrado."))
              : ListView.builder(
                itemCount: _listaPessoas.length,
                itemBuilder: (_, index) {
                  final pessoa = _listaPessoas[index];

                  return Dismissible(
                    key: Key(
                      "perfil_${pessoa.key}_${pessoa.nome}_${_random.nextInt(10000)}",
                    ),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red[800],
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text(
                            "Apagar Utilizador",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Excluir Utilizador?"),
                            content: Text(
                              "Tem certeza que deseja apagar '${pessoa.nome}'?\n\n⚠️ Todo o histórico será perdido.",
                            ),
                            actions: [
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(false),
                                child: const Text("Cancelar"),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                                child: const Text(
                                  "Sim, Excluir",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) {
                      pessoa.delete();
                      setState(() {
                        _carregarDados();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "O perfil de ${pessoa.nome} foi apagado.",
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(8),
                      child: ExpansionTile(
                        key: Key(
                          "tile_${pessoa.key}_${_random.nextInt(10000)}",
                        ),
                        title: Text(
                          pessoa.nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        children:
                            pessoa.registros.isEmpty
                                ? [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Nenhum registro ainda."),
                                  ),
                                ]
                                : [
                                  _construirGraficoEvolucao(pessoa.registros),
                                  const Divider(),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Histórico Detalhado",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ...pessoa.registros.asMap().entries.map((
                                    entry,
                                  ) {
                                    int indexReg = entry.key;
                                    var registro = entry.value;

                                    String classificacao =
                                        CalculadorDeImc.classificacaoIMC(
                                          registro.imc,
                                        );

                                    return Dismissible(
                                      key: Key(
                                        "imc_${pessoa.key}_${registro.data.millisecondsSinceEpoch}_${_random.nextInt(10000)}",
                                      ),
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onDismissed: (direction) {
                                        setState(() {
                                          pessoa.registros.removeAt(indexReg);
                                          pessoa.save();
                                        });
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text("Registro apagado!"),
                                            backgroundColor: Colors.redAccent,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            left: BorderSide(
                                              color: _corParaNivelIMC(
                                                classificacao,
                                              ),
                                              width: 6,
                                            ),
                                          ),
                                        ),
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.monitor_weight,
                                            color: _corParaNivelIMC(
                                              classificacao,
                                            ),
                                          ),
                                          title: Text(
                                            "IMC: ${registro.imc.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "Peso: ${registro.peso} kg\n"
                                            "Altura: ${registro.altura} m\n"
                                            "Classificação: $classificacao\n"
                                            "Data: ${registro.data.day.toString().padLeft(2, '0')}/${registro.data.month.toString().padLeft(2, '0')}/${registro.data.year}",
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
