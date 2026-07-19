import 'package:calculadora_imc/model/pessoa_model.dart';
import 'package:calculadora_imc/model/sessao_usuario.dart';
import 'package:calculadora_imc/page/atividade_page.dart';
import 'package:calculadora_imc/page/calcular_imc_page.dart';
import 'package:calculadora_imc/page/configuracoes_page.dart';
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
                        setState(() {
                          _sessao.selecionarUsuario(pessoa);
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Perfil alterado para ${pessoa.nome}",
                            ),
                          ),
                        );
                      },
                    );
                  }),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(Icons.person_add, color: Colors.blue),
                  ),
                  title: const Text(
                    "Criar / Editar Novo Perfil",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConfiguracoesPage(),
                      ),
                    ).then((_) {
                      // Se o utilizador criou um perfil e voltou, atualizamos a lista!
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

  // 🔥 Método limpo para tratar a ação do botão flutuante
  void _aoClicarNoBotaoFlutuante() {
    if (_indiceAba == 1) {
      // 1 = Histórico IMC
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CalcularImcPage()),
      );
    } else if (_indiceAba == 2) {
      // 2 = Atividades
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AtividadePage()),
      );
    }
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
        // 🔥 A aba de calcular IMC renderiza a página diretamente
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
      // 🔥 O botão flutuante não é mais necessário na aba de calcular IMC (índice 3)
      floatingActionButton:
          (_indiceAba == 0 || _indiceAba == 3)
              ? null
              : FloatingActionButton(
                onPressed: _aoClicarNoBotaoFlutuante,
                child: const Icon(Icons.add),
              ),
      bottomNavigationBar: BottomNavigationBar(
        type:
            BottomNavigationBarType
                .fixed, // Permite mais de 3 itens com cores visíveis
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
          // 🔥 Novo botão para calcular o IMC
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: "Calcular IMC",
          ),
        ],
      ),
    );
  }
}
