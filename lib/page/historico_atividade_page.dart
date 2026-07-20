import 'package:calculadora_imc/model/sessao_usuario.dart';
import 'package:calculadora_imc/service_locator.dart';
import 'package:flutter/material.dart';

class HistoricoAtividadePage extends StatefulWidget {
  const HistoricoAtividadePage({super.key});

  @override
  State<HistoricoAtividadePage> createState() => _HistoricoAtividadePageState();
}

class _HistoricoAtividadePageState extends State<HistoricoAtividadePage> {
  // 🔥 FASE 3: Em vez de ir buscar todas as pessoas ao repositório,
  // lemos diretamente o perfil ativo na sessão!
  final _sessao = getIt<SessaoUsuario>();

  @override
  void initState() {
    super.initState();
    // Ouve as alterações de sessão para atualizar a lista se o perfil mudar
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

  @override
  Widget build(BuildContext context) {
    final usuario = _sessao.usuarioAtivo;

    return Scaffold(
      body:
          usuario == null
              // Se não há ninguém selecionado
              ? const Center(
                child: Text(
                  "Nenhum perfil ativo.\nSelecione um perfil no ecrã inicial.",
                  textAlign: TextAlign.center,
                ),
              )
              // Se o utilizador não tem atividades
              : usuario.atividades.isEmpty
              ? Center(
                child: Text(
                  "Olá, ${usuario.nome}!\nAinda não registaste nenhuma atividade.",
                  textAlign: TextAlign.center,
                ),
              )
              // Se tem atividades, mostra a lista dele!
              : SafeArea(
                child: ListView.builder(
                  itemCount: usuario.atividades.length,
                  itemBuilder: (_, index) {
                    // Vamos inverter a ordem para ver a mais recente primeiro
                    final atividade =
                        usuario.atividades[usuario.atividades.length -
                            1 -
                            index];

                    return Dismissible(
                      key: Key('ativ_${atividade.data.millisecondsSinceEpoch}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        // 🔥 Apaga a atividade e guarda as alterações no perfil
                        setState(() {
                          usuario.atividades.remove(atividade);
                          usuario.save();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Atividade removida!')),
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
                            "Data: ${atividade.data.day}/${atividade.data.month}/${atividade.data.year}",
                          ),
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
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
