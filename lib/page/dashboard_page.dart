import 'package:calculadora_imc/calcularIMC/calculador_de_imc.dart';
import 'package:calculadora_imc/model/registro_imc_model.dart';
import 'package:calculadora_imc/model/sessao_usuario.dart';
import 'package:calculadora_imc/service/atividade_analise_service.dart';
import 'package:calculadora_imc/service/imc_analise_service.dart';
import 'package:calculadora_imc/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // 💡 DEPENDÊNCIAS: Apenas a sessão e os serviços de análise!
  final _sessao = getIt<SessaoUsuario>();
  final _imcService = ImcAnaliseService();
  final _atividadeService = AtividadeAnaliseService();

  @override
  void initState() {
    super.initState();
    // 💡 Escuta as mudanças de perfil. Se a pessoa ativa mudar, o Dashboard redesenha-se!
    _sessao.addListener(_atualizarDashboard);
  }

  @override
  void dispose() {
    // 💡 Limpeza para não gastar memória quando o ecrã for fechado
    _sessao.removeListener(_atualizarDashboard);
    super.dispose();
  }

  void _atualizarDashboard() {
    if (mounted) setState(() {});
  }

  // ------------------------------------------------------------------------
  // WIDGETS AUXILIARES (CARDS)
  // ------------------------------------------------------------------------

  // 💡 Cria os pequenos cartões coloridos no topo do Dashboard
  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 💡 Cria o cartão que mostra o quão perto a pessoa está da sua meta de peso
  Widget _buildProgressoMetaCard(
    double pesoAtual,
    double pesoMeta,
    String objetivo,
  ) {
    if (pesoMeta <= 0)
      return const SizedBox.shrink(); // Não mostra se não houver meta configurada

    double diferenca = pesoAtual - pesoMeta;
    String statusTexto = "";
    Color corStatus = Colors.blue;
    double progresso = 0.0;

    // Lógica inteligente de progresso baseada no Objetivo do Perfil
    if (objetivo == "Emagrecer") {
      if (diferenca <= 0) {
        statusTexto = "Parabéns! Meta Alcançada!";
        corStatus = Colors.green;
        progresso = 1.0;
      } else {
        statusTexto = "Faltam ${diferenca.toStringAsFixed(1)} kg para a meta.";
        corStatus = Colors.orange;
        // Progresso ilustrativo (num cenário real compararia com o peso inicial)
        progresso = 0.5;
      }
    } else if (objetivo == "Hipertrofia") {
      if (diferenca >= 0) {
        statusTexto = "Parabéns! Meta Alcançada!";
        corStatus = Colors.green;
        progresso = 1.0;
      } else {
        statusTexto =
            "Faltam ${diferenca.abs().toStringAsFixed(1)} kg para a meta.";
        corStatus = Colors.blueAccent;
        progresso = 0.5;
      }
    } else {
      statusTexto =
          "A manter o peso em torno de ${pesoMeta.toStringAsFixed(1)} kg.";
      corStatus = Colors.teal;
      progresso = 1.0;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Progresso da Meta",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.flag, color: corStatus),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              statusTexto,
              style: TextStyle(
                fontSize: 14,
                color: corStatus,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progresso,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(corStatus),
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------------
  // CONSTRUÇÃO PRINCIPAL
  // ------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // 💡 Acesso ao Perfil Dinâmico: Todos os dados desta página vêm daqui!
    final usuario = _sessao.usuarioAtivo;

    // 💡 CENÁRIO: Ninguém logado (Prevenção de Erros de Tela Vazia)
    if (usuario == null) {
      return const Center(
        child: Text(
          "Bem-vindo ao IMC+!\nSelecione ou crie um perfil no topo.",
          textAlign: TextAlign.center,
        ),
      );
    }

    // 💡 Recupera os dados exclusivos do utilizador selecionado
    final registros = usuario.registros;
    final temRegistos = registros.isNotEmpty;

    final ultimoImc = temRegistos ? registros.last.imc : 0.0;
    final ultimoPeso = temRegistos ? registros.last.peso : 0.0;

    // Cálculo do total de minutos de atividade da pessoa logada
    int tempoTotalAtividades = 0;
    for (var ativ in usuario.atividades) {
      tempoTotalAtividades += ativ.duracao;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // SAUDAÇÃO PERSONALIZADA
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Resumo de ${usuario.nome}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // CARDS SUPERIORES
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      "Último IMC",
                      temRegistos ? ultimoImc.toStringAsFixed(1) : "--",
                      Icons.speed,
                      temRegistos
                          ? (ultimoImc >= 18.5 && ultimoImc < 25
                              ? Colors.green
                              : Colors.orange)
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      "Min. Ativos",
                      tempoTotalAtividades > 0 ? "$tempoTotalAtividades" : "0",
                      Icons.local_fire_department,
                      tempoTotalAtividades > 0 ? Colors.redAccent : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 💡 CARTÃO DE META DE PESO
            if (temRegistos && usuario.pesoMeta > 0)
              _buildProgressoMetaCard(
                ultimoPeso,
                usuario.pesoMeta,
                usuario.objetivo,
              ),

            const SizedBox(height: 20),

            // GRÁFICO DE EVOLUÇÃO
            if (registros.length >= 2) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Evolução do IMC",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              _construirGrafico(registros),
            ] else ...[
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  "Adicione pelo menos 2 medições de IMC para ver o gráfico de evolução.",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            const SizedBox(height: 20),

            // ANÁLISE DE INSIGHTS (Lida dos Serviços)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Insights de Saúde",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔥 CORREÇÃO DA LINHA 305: A função certa chama-se 'calcularTendencia' e pede a lista de registros!
                    Text(
                      "💡 ${_imcService.calcularTendencia(usuario.registros)}",
                      style: const TextStyle(fontSize: 15),
                    ),
                    const Divider(),
                    Text(
                      "💪 ${_atividadeService.atividadeMaisFrequente(usuario)}",
                      style: const TextStyle(fontSize: 15),
                    ),
                    const Divider(),
                    Text(
                      "📊 ${_atividadeService.impactoNoImc(usuario)}",
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------------
  // LÓGICA DO GRÁFICO (FL_CHART)
  // ------------------------------------------------------------------------
  Widget _construirGrafico(List<RegistroImcModel> registros) {
    List<double> valoresImc = registros.map((r) => r.imc).toList();
    double minImc = valoresImc.reduce(min);
    double maxImc = valoresImc.reduce(max);

    double minY = (minImc - 1.0).floorToDouble();
    double maxY = (maxImc + 1.0).ceilToDouble();

    List<FlSpot> pontos =
        registros
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value.imc))
            .toList();

    return Container(
      height: 200,
      padding: const EdgeInsets.only(right: 20.0, left: 10.0),
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1.0,
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
                reservedSize: 35,
                interval: 1.0,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    meta: meta,
                    space: 5.0,
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
              spots: pontos,
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
