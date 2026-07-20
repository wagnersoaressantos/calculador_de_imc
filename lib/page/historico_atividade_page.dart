import 'package:calculadora_imc/model/atividade_model.dart';
import 'package:calculadora_imc/model/pessoa_model.dart';
import 'package:calculadora_imc/model/sessao_usuario.dart';
import 'package:calculadora_imc/service_locator.dart';
import 'package:flutter/material.dart';

class HistoricoAtividadePage extends StatefulWidget {
  const HistoricoAtividadePage({super.key});

  @override
  State<HistoricoAtividadePage> createState() => _HistoricoAtividadePageState();
}

class _HistoricoAtividadePageState extends State<HistoricoAtividadePage> {
  final _sessao = getIt<SessaoUsuario>();

  @override
  void initState() {
    super.initState();
    _sessao.addListener(_atualizarTela);
  }

  @override
  void dispose() {
    _sessao.removeListener(_atualizarTela);
    super.dispose();
  }

  void _atualizarTela() {
    if (mounted) setState(() {});
  }

  // 🔥 FASE 4: Função para editar um registro sem precisar apagar
  void _mostrarDialogoEdicao(PessoaModel pessoa, AtividadeModel atividade) {
    final tipoController = TextEditingController(text: atividade.tipo);
    final duracaoController = TextEditingController(
      text: atividade.duracao.toString(),
    );
    String intensidadeSelecionada = atividade.intensidade;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Editar Atividade"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: tipoController,
                    decoration: const InputDecoration(
                      labelText: "Atividade",
                      prefixIcon: Icon(Icons.directions_run),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: duracaoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Duração (min)",
                      prefixIcon: Icon(Icons.timer),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: intensidadeSelecionada,
                    items:
                        ["Leve", "Moderada", "Intensa"]
                            .map(
                              (i) => DropdownMenuItem(value: i, child: Text(i)),
                            )
                            .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setStateDialog(() => intensidadeSelecionada = val);
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: "Intensidade",
                      prefixIcon: Icon(Icons.fitness_center),
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
                    int novaDuracao = int.tryParse(duracaoController.text) ?? 0;
                    if (tipoController.text.isNotEmpty && novaDuracao > 0) {
                      setState(() {
                        // Atualiza a atividade
                        atividade.tipo = tipoController.text.trim();
                        atividade.duracao = novaDuracao;
                        atividade.intensidade = intensidadeSelecionada;
                        atividade.caloriasGastas =
                            novaDuracao * 5.0; // Recálculo básico
                        pessoa.save(); // Salva no Hive
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Atividade atualizada com sucesso!"),
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
                  child: const Text("Guardar Alterações"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = _sessao.usuarioAtivo;

    return Scaffold(
      body:
          usuario == null
              ? const Center(
                child: Text(
                  "Nenhum perfil ativo.\nSelecione um perfil no topo do ecrã.",
                  textAlign: TextAlign.center,
                ),
              )
              : usuario.atividades.isEmpty
              ? Center(
                child: Text(
                  "Olá, ${usuario.nome}!\nAinda não registaste nenhuma atividade.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : SafeArea(
                child: ListView.builder(
                  itemCount: usuario.atividades.length,
                  itemBuilder: (_, index) {
                    final atividade =
                        usuario.atividades[usuario.atividades.length -
                            1 -
                            index];

                    // Formatação enriquecida de Data e Hora
                    final dataStr =
                        "${atividade.data.day.toString().padLeft(2, '0')}/${atividade.data.month.toString().padLeft(2, '0')}/${atividade.data.year}";
                    final horaStr =
                        "${atividade.data.hour.toString().padLeft(2, '0')}:${atividade.data.minute.toString().padLeft(2, '0')}";

                    return Dismissible(
                      key: Key('ativ_${atividade.data.millisecondsSinceEpoch}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete, color: Colors.white, size: 30),
                            Text(
                              "Apagar",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 🔥 AQUI ESTÁ A CONFIRMAÇÃO DE EXCLUSÃO (FASE 4)
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Excluir Atividade?"),
                              content: const Text(
                                "Tem certeza que deseja apagar esta atividade?\n\nEsta ação não pode ser desfeita.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  child: const Text(
                                    "Cancelar",
                                    style: TextStyle(color: Colors.grey),
                                  ),
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
                        setState(() {
                          usuario.atividades.remove(atividade);
                          usuario.save();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Atividade removida!'),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.local_fire_department,
                            color: Colors.deepOrange,
                            size: 32,
                          ),
                          title: Text(
                            "${atividade.tipo} (${atividade.duracao} min)",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Intensidade: ${atividade.intensidade}\n"
                            "Data: $dataStr às $horaStr", // 🔥 FASE 4: Hora Exata
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                atividade.caloriasGastas != null
                                    ? "${atividade.caloriasGastas!.toStringAsFixed(0)} kcal"
                                    : "---",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                  fontSize: 16,
                                ),
                              ),
                              // 🔥 FASE 4: Botão de Edição
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed:
                                    () => _mostrarDialogoEdicao(
                                      usuario,
                                      atividade,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
