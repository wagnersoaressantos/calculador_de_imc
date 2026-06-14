import 'package:calculadora_imc/model/atividade_model.dart';
import 'package:calculadora_imc/repository/pessoa_repository.dart';
import 'package:calculadora_imc/service_locator.dart';
import 'package:flutter/material.dart';

class AtividadePage extends StatefulWidget {
  const AtividadePage({super.key});

  @override
  State<AtividadePage> createState() => _AtividadePageState();
}

class _AtividadePageState extends State<AtividadePage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _duracaoController = TextEditingController();

  String _tipoSelecionado = "Caminhada";
  String _intensidadeSelecionada = "Leve";

  final _repo = getIt<PessoaRepository>();

  // 🔥 NOVO: O "Cérebro" que calcula as calorias usando a tabela MET
  double _calcularCalorias(
    String tipo,
    String intensidade,
    int duracaoMinutos,
    double peso,
  ) {
    double met = 3.0; // Valor padrão de segurança

    if (tipo == "Caminhada") {
      if (intensidade == "Leve")
        met = 2.5;
      else if (intensidade == "Moderada")
        met = 3.8;
      else
        met = 5.0; // Alta
    } else if (tipo == "Corrida") {
      if (intensidade == "Leve")
        met = 6.0;
      else if (intensidade == "Moderada")
        met = 8.0;
      else
        met = 10.0;
    } else if (tipo == "Academia") {
      if (intensidade == "Leve")
        met = 3.0;
      else if (intensidade == "Moderada")
        met = 5.0;
      else
        met = 6.0;
    }

    // Fórmula: MET * Peso * Tempo em Horas
    return met * peso * (duracaoMinutos / 60.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Atividade")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: "Seu nome",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _tipoSelecionado,
                decoration: const InputDecoration(
                  labelText: "Tipo de Atividade",
                  border: OutlineInputBorder(),
                ),
                items:
                    ["Caminhada", "Corrida", "Academia"]
                        .map(
                          (tipo) =>
                              DropdownMenuItem(value: tipo, child: Text(tipo)),
                        )
                        .toList(),
                onChanged: (value) => setState(() => _tipoSelecionado = value!),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _duracaoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Duração (minutos)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _intensidadeSelecionada,
                decoration: const InputDecoration(
                  labelText: "Intensidade",
                  border: OutlineInputBorder(),
                ),
                items:
                    ["Leve", "Moderada", "Alta"]
                        .map(
                          (nivel) =>
                              DropdownMenuItem(value: nivel, child: Text(nivel)),
                        )
                        .toList(),
                onChanged:
                    (value) => setState(() => _intensidadeSelecionada = value!),
              ),
              const SizedBox(height: 20),
        
              // 🔥 BOTÃO DE SALVAR REFORMULADO
              ElevatedButton(
                onPressed: () {
                  if (_nomeController.text.isEmpty ||
                      _duracaoController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Preencha todos os campos!")),
                    );
                    return;
                  }
        
                  final duracao = int.tryParse(_duracaoController.text) ?? 0;
                  final pessoa = _repo.obterOuCriarPessoa(
                    _nomeController.text,
                    0,
                  );
        
                  if (pessoa != null) {
                    // 1. Inteligência: Buscar o último peso da pessoa
                    double pesoAtual =
                        70.0; // Peso "chutado" se for um usuário virgem
                    if (pessoa.registros.isNotEmpty) {
                      // Pega o peso do último registro de IMC feito na outra tela!
                      pesoAtual = pessoa.registros.last.peso;
                    }
        
                    // 2. Calcula as calorias com base no peso real
                    double calorias = _calcularCalorias(
                      _tipoSelecionado,
                      _intensidadeSelecionada,
                      duracao,
                      pesoAtual,
                    );
        
                    // 3. Cria a atividade incluindo as calorias
                    final atividade = AtividadeModel(
                      tipo: _tipoSelecionado,
                      duracao: duracao,
                      intensidade: _intensidadeSelecionada,
                      data: DateTime.now(),
                      caloriasGastas: calorias,
                    );
        
                    pessoa.atividades.add(atividade);
                    pessoa.save();
        
                    // 4. Mostra o Feedback super interativo e encorajador
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "🔥 Sucesso! Você queimou cerca de ${calorias.toStringAsFixed(0)} kcal.",
                        ),
                        backgroundColor:
                            Colors.orange, // Laranja combinando com fogo/calorias
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    debugPrint("Erro: Pessoa retornou nula.");
                  }
        
                  _nomeController.clear();
                  _duracaoController.clear();
                },
                child: const Text("Salvar Atividade"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
