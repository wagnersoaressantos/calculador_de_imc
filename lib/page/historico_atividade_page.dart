import 'package:calculadora_imc/model/pessoa_model.dart';
import 'package:calculadora_imc/page/atividade_page.dart';
import 'package:calculadora_imc/repository/pessoa_repository.dart';
import 'package:calculadora_imc/service_locator.dart';
import 'package:flutter/material.dart';

class HistoricoAtividadePage extends StatefulWidget {
  const HistoricoAtividadePage({super.key});

  @override
  State<HistoricoAtividadePage> createState() => _HistoricoAtividadePageState();
}

class _HistoricoAtividadePageState extends State<HistoricoAtividadePage> {
  // Chamamos o repositório a partir da nossa "Caixa de Ferramentas"
  final _repo = getIt<PessoaRepository>();
  List<PessoaModel> _listaPessoas = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Histórico de Atividades")),

      // 🔹 O Botão que leva para o Formulário de Atividades
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // Vai para a tela de registro e "espera" o usuário voltar
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AtividadePage()),
          );
          // Quando o usuário voltar, recarrega a lista para mostrar a nova atividade!
          _carregarDados();
        },
      ),

      // 🔹 A Lista de Pessoas e Atividades
      body:
          _listaPessoas.isEmpty
              ? const Center(child: Text("Nenhum usuário cadastrado."))
              : ListView.builder(
                itemCount: _listaPessoas.length,
                itemBuilder: (_, index) {
                  final pessoa = _listaPessoas[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ExpansionTile(
                      leading: const Icon(
                        Icons.directions_run,
                        color: Colors.orange,
                      ),
                      title: Text(
                        pessoa.nome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      children:
                          pessoa.atividades.isEmpty
                              ? [
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    "Nenhuma atividade registrada.",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ]
                              : pessoa.atividades.map((atividade) {
                                return ListTile(
                                  // Ícone de fogo para representar as calorias
                                  leading: const Icon(
                                    Icons.local_fire_department,
                                    color: Colors.deepOrange,
                                  ),
                                  title: Text(
                                    "${atividade.tipo} (${atividade.duracao} min)",
                                  ),
                                  subtitle: Text(
                                    "Intensidade: ${atividade.intensidade}\n"
                                    "Data: ${atividade.data.day}/${atividade.data.month}/${atividade.data.year}",
                                  ),
                                  // Mostra as calorias calculadas à direita
                                  trailing: Text(
                                    atividade.caloriasGastas != null
                                        ? "${atividade.caloriasGastas!.toStringAsFixed(0)} kcal"
                                        : "---",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }).toList(),
                    ),
                  );
                },
              ),
    );
  }
}
