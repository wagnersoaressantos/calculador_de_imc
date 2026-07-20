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
    setState(() {
      _listaPessoas = _repo.listarPessoas();
    });
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

  // 🔥 FASE 4: Modal de edição de peso e altura do registo passado
  void _mostrarDialogoEdicao(PessoaModel pessoa, RegistroImcModel registro) {
    final pesoController = TextEditingController(
      text: registro.peso.toString(),
    );
    final alturaController = TextEditingController(
      text: registro.altura.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Medição"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pesoController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Peso (kg)",
                  prefixIcon: Icon(Icons.monitor_weight),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: alturaController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Altura (m)",
                  prefixIcon: Icon(Icons.height),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                double novoPeso =
                    double.tryParse(pesoController.text.replaceAll(',', '.')) ??
                    0;
                double novaAltura =
                    double.tryParse(
                      alturaController.text.replaceAll(',', '.'),
                    ) ??
                    0;

                if (novoPeso >= 2.0 && novaAltura >= 0.4) {
                  if (novaAltura > 3.0) novaAltura = novaAltura / 100;
                  setState(() {
                    registro.peso = novoPeso;
                    registro.altura = novaAltura;
                    registro.imc = novoPeso / (novaAltura * novaAltura);
                    pessoa.save(); // Salva as alterações
                    _carregarDados(); // Força a atualização do gráfico
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Registo atualizado com sucesso!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Valores inválidos."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Guardar Correção"),
            ),
          ],
        );
      },
    );
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

    List<double> valoresImc = registros.map((r) => r.imc).toList();
    double minImc = valoresImc.reduce(min);
    double maxImc = valoresImc.reduce(max);

    double minY = (minImc - 2.0).floorToDouble();
    double maxY = (maxImc + 2.0).ceilToDouble();
    double intervalo = (maxY - minY) > 10 ? 2.0 : 1.0;

    List<FlSpot> pontosDoGrafico =
        registros.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.imc);
        }).toList();

    return Container(
      height: 250,
      padding: const EdgeInsets.only(
        right: 20.0,
        left: 10.0,
        top: 24.0,
        bottom: 12.0,
      ),
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor:
                  (LineBarSpot touchedSpot) => Colors.blueGrey.withOpacity(0.8),
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
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
            drawVerticalLine: false,
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
                reservedSize: 40,
                interval: intervalo,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    meta: meta,
                    space: 8.0,
                    child: Text(
                      value.toStringAsFixed(0),
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
              barWidth: 3,
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

                                    // 🔥 FASE 4: Enriquecimento de Data e Hora
                                    final dataStr =
                                        "${registro.data.day.toString().padLeft(2, '0')}/${registro.data.month.toString().padLeft(2, '0')}/${registro.data.year}";
                                    final horaStr =
                                        "${registro.data.hour.toString().padLeft(2, '0')}:${registro.data.minute.toString().padLeft(2, '0')}";

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
                                      // 🔥 CORREÇÃO FASE 4: Confirmação antes de apagar medição individual de IMC
                                      confirmDismiss: (direction) async {
                                        return await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                "Excluir Registo?",
                                              ),
                                              content: const Text(
                                                "Tem certeza que deseja apagar esta medição de IMC?\n\nEsta ação não pode ser desfeita.",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.of(
                                                        context,
                                                      ).pop(false),
                                                  child: const Text(
                                                    "Cancelar",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                  onPressed:
                                                      () => Navigator.of(
                                                        context,
                                                      ).pop(true),
                                                  child: const Text(
                                                    "Sim, Excluir",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
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
                                            "Classificação: $classificacao\n"
                                            "Data: $dataStr às $horaStr", // Hora inserida
                                          ),
                                          // 🔥 FASE 4: Lápis de edição ao lado
                                          trailing: IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.blue,
                                            ),
                                            onPressed:
                                                () => _mostrarDialogoEdicao(
                                                  pessoa,
                                                  registro,
                                                ),
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
