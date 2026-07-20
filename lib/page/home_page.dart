import 'package:calculadora_imc/model/sessao_usuario.dart';
import 'package:calculadora_imc/page/atividade_page.dart';
import 'package:calculadora_imc/page/calcular_imc_page.dart';
import 'package:calculadora_imc/page/perfil_page.dart';
import 'package:calculadora_imc/page/dashboard_page.dart';
import 'package:calculadora_imc/page/historico_atividade_page.dart';
import 'package:calculadora_imc/page/historico_imc_page.dart';
import 'package:calculadora_imc/repository/pessoa_repository.dart';
import 'package:calculadora_imc/service_locator.dart';
import 'package:calculadora_imc/share/widget/custon_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indiceAba = 0;
  final _repo = getIt<PessoaRepository>();
  final _sessao = getIt<SessaoUsuario>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_sessao.usuarioAtivo == null) {
        final pessoas = _repo.listarPessoas();
        if (pessoas.isNotEmpty) {
          _sessao.selecionarUsuario(pessoas.first);
        }
      }
    });

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

  void _mudarAba(int indice) {
    setState(() {
      _indiceAba = indice;
    });
  }

  void _mostrarSeletorDePerfil() {
    final pessoas = _repo.listarPessoas();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Quem está a utilizar o App?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Divider(),
                if (pessoas.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Nenhum perfil encontrado. Crie um novo!"),
                  )
                else
                  ...pessoas.map((pessoa) {
                    bool isAtivo = _sessao.usuarioAtivo?.key == pessoa.key;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            isAtivo ? Colors.green : Colors.blueGrey,
                        child: Text(
                          pessoa.nome.isNotEmpty
                              ? pessoa.nome[0].toUpperCase()
                              : "?",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        pessoa.nome,
                        style: TextStyle(
                          fontWeight:
                              isAtivo ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing:
                          isAtivo
                              ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                              : null,
                      onTap: () {
                        _sessao.selecionarUsuario(pessoa);
                        Navigator.pop(context);
                      },
                    );
                  }),
                const Divider(),

                // 🔥 CORREÇÃO: Adicionámos a opção de Editar o perfil que está selecionado agora
                if (_sessao.usuarioAtivo != null)
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.edit, color: Colors.orange),
                    ),
                    title: Text(
                      "Editar Perfil (${_sessao.usuarioAtivo!.nome})",
                      style: const TextStyle(color: Colors.orange),
                    ),
                    onTap: () {
                      Navigator.pop(context); // Fecha a lista
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // Envia o perfil ativo para a página forçar o MODO EDIÇÃO
                          builder:
                              (context) => PerfilPage(
                                pessoaExistente: _sessao.usuarioAtivo,
                              ),
                        ),
                      ).then((_) {
                        setState(() {});
                      });
                    },
                  ),

                // Botão de Criar (Continua a mandar vazio para modo criação)
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(Icons.person_add, color: Colors.blue),
                  ),
                  title: const Text(
                    "Criar Novo Perfil",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      // Não passa utilizador nenhum = MODO CRIAÇÃO
                      MaterialPageRoute(
                        builder: (context) => const PerfilPage(),
                      ),
                    ).then((_) {
                      setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget corpoAba;
    switch (_indiceAba) {
      case 0:
        corpoAba = const DashboardPage();
        break;
      case 1:
        corpoAba = const HistoricoImcPage();
        break;
      case 2:
        corpoAba = const HistoricoAtividadePage();
        break;
      case 3:
        corpoAba = const CalcularImcPage();
        break;
      default:
        corpoAba = const DashboardPage();
        break;
    }

    String nomePerfilAtual = _sessao.usuarioAtivo?.nome ?? "Selecionar Perfil";

    return Scaffold(
      drawer: const CustonDrawer(),
      appBar: AppBar(
        title: const Text("IMC +"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ActionChip(
              avatar: const Icon(Icons.person, size: 16),
              label: Text(
                nomePerfilAtual,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: _mostrarSeletorDePerfil,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
        ],
      ),
      body: corpoAba,
      floatingActionButton:
          (_indiceAba == 0 || _indiceAba == 3)
              ? null
              : FloatingActionButton(
                onPressed: () {
                  if (_indiceAba == 1) {
                    setState(() {
                      _indiceAba = 3;
                    });
                  } else if (_indiceAba == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AtividadePage(),
                      ),
                    );
                  }
                },
                child: const Icon(Icons.add),
              ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _indiceAba,
        onTap: _mudarAba,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Histórico IMC",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: "Atividades",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: "Calcular IMC",
          ),
        ],
      ),
    );
  }
}
