import 'package:calculadora_imc/calcularIMC/calculador_de_imc.dart';
import 'package:calculadora_imc/model/pessoa_model.dart';
import 'package:calculadora_imc/model/registro_imc_model.dart'; // Adicionado para aceder ao modelo
import 'package:calculadora_imc/page/calcular_imc_page.dart';
import 'package:calculadora_imc/repository/pessoa_repository.dart';
import 'package:calculadora_imc/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Importante: O pacote do gráfico

class HistoricoImcPage extends StatefulWidget {
  const HistoricoImcPage({super.key});

  @override
  State<HistoricoImcPage> createState() => _HistoricoImcPageState();
}

class _HistoricoImcPageState extends State<HistoricoImcPage> {
  final _repo = getIt<PessoaRepository>();
  List<PessoaModel> _listaPessoas = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    _listaPessoas = _repo.listarPessoas();
  }

  /// NOVO MÉTODO: Cria o widget do gráfico de linha
  /// Recebe a lista de registos de uma pessoa e desenha a evolução do IMC.
  Widget _construirGraficoEvolucao(List<RegistroImcModel> registros) {
    // Se tiver menos de 2 registos, não desenhamos a linha, pois precisamos
    // de pelo menos dois pontos para conectar.
    if (registros.length < 2) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "Adiciona mais medições para veres o gráfico de evolução do IMC.",
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    // Convertendo a lista de registos em pontos (FlSpot) para o fl_chart
    List<FlSpot> pontosDoGrafico =
        registros.asMap().entries.map((entry) {
          // entry.key é o índice (0, 1, 2...) que será o nosso eixo X (tempo)
          // entry.value é o RegistroImcModel, do qual tiramos o IMC para o eixo Y
          return FlSpot(entry.key.toDouble(), entry.value.imc);
        }).toList();

    // Retorna o gráfico envolto num Container para limitar a sua altura
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: LineChart(
        LineChartData(
          // Estilização básica do gráfico
          gridData: FlGridData(show: false), // Esconde a grelha de fundo
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: pontosDoGrafico, // Aqui passamos os nossos pontos!
              isCurved: true, // Deixa a linha com curvas suaves
              color:
                  Theme.of(
                    context,
                  ).primaryColor, // Usa a cor principal do teu tema
              barWidth: 4, // Espessura da linha
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
              ), // Mostra uma bolinha em cada medição
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context).primaryColor.withOpacity(
                  0.2,
                ), // Efeito de sombra abaixo da linha
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
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ExpansionTile(
                      title: Text(
                        pessoa.nome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      // Aqui alteramos a forma como os 'children' são construídos
                      children:
                          pessoa.registros.isEmpty
                              ? [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Nenhum registo ainda."),
                                ),
                              ]
                              : [
                                // 1º Colocamos o nosso novo gráfico no topo!
                                _construirGraficoEvolucao(pessoa.registros),

                                // 2º Colocamos um pequeno título para a lista
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

                                // 3º Espalhamos os ListTile com os dados em texto (como já tinhas)
                                ...pessoa.registros.map((registro) {
                                  return ListTile(
                                    leading: const Icon(Icons.monitor_weight),
                                    title: Text(
                                      "IMC: ${registro.imc.toStringAsFixed(2)}",
                                    ),
                                    subtitle: Text(
                                      "Peso: ${registro.peso} kg\n"
                                      "Classificação: ${CalculadorDeImc.classificacaoIMC(registro.imc)} \n"
                                      "Data: ${registro.data.day}/${registro.data.month}/${registro.data.year}",
                                    ),
                                  );
                                }),
                              ],
                    ),
                  );
                },
              ),
    );
  }
}
