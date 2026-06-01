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
  // 🔹 Controller para capturar o nome da pessoa
  final TextEditingController _nomeController = TextEditingController();

  // 🔹 Controller para capturar a duração
  final TextEditingController _duracaoController = TextEditingController();

  // 🔹 Tipo de atividade selecionado
  String _tipoSelecionado = "Caminhada";

  // 🔹 Intensidade selecionada
  String _intensidadeSelecionada = "Leve";

  // 🔹 Repository para salvar os dados
final _repo = getIt<PessoaRepository>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Atividade")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Campo de nome
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: "Seu nome",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 Dropdown de tipo de atividade
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
              onChanged: (value) {
                setState(() {
                  _tipoSelecionado = value!;
                });
              },
            ),

            const SizedBox(height: 10),

            // 🔹 Campo de duração
            TextField(
              controller: _duracaoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Duração (minutos)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 Dropdown de intensidade
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
              onChanged: (value) {
                setState(() {
                  _intensidadeSelecionada = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // 🔥 BOTÃO DE SALVAR
            ElevatedButton(
              onPressed: () {
                // 🔹 Validação simples
                if (_nomeController.text.isEmpty ||
                    _duracaoController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Preencha todos os campos!")),
                  );
                  return;
                }

                // 🔹 Converte duração para int
                final duracao = int.tryParse(_duracaoController.text) ?? 0;

                // 🔹 Cria objeto de atividade
                final atividade = AtividadeModel(
                  tipo: _tipoSelecionado,
                  duracao: duracao,
                  intensidade: _intensidadeSelecionada,
                  data: DateTime.now(), // salva data atual automaticamente
                );

                // 🔹 Busca ou cria a pessoa
                final pessoa = _repo.obterOuCriarPessoa(
                  _nomeController.text,
                  0, // altura não importa aqui (já pode existir)
                );

                if (pessoa != null) {
                  pessoa.atividades.add(atividade);
                  pessoa.save();
                } else {
                  // Opcional: Mostrar um SnackBar de erro se a pessoa não for encontrada
                  debugPrint(
                    "Erro: Pessoa retornou nula ao tentar salvar atividade.",
                  );
                }
                // 🔹 Feedback pro usuário
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Atividade salva com sucesso!")),
                );

                // 🔹 Limpa os campos
                _nomeController.clear();
                _duracaoController.clear();
              },
              child: const Text("Salvar Atividade"),
            ),
          ],
        ),
      ),
    );
  }
}
