import 'package:calculadora_imc/page/configuracoes_page.dart';
import 'package:calculadora_imc/page/dashboard_page.dart';
import 'package:calculadora_imc/repository/configuracoes_repository.dart';
import 'package:flutter/material.dart';

class CustonDrawer extends StatefulWidget {
  const CustonDrawer({super.key});

  @override
  State<CustonDrawer> createState() => _CustonDrawerState();
}

class _CustonDrawerState extends State<CustonDrawer> {
  // Variáveis com valores iniciais enquanto os dados carregam
  String _nomeUsuario = "Carregando...";
  String _alturaUsuario = "";

  @override
  void initState() {
    super.initState();
    _carregarDadosPerfil();
  }

  // 🧠 A MAGIA: Vai na memória do telemóvel buscar a configuração salva!
  void _carregarDadosPerfil() async {
    final repo = await ConfiguracoesRepository.load();
    final config = repo.pegarDados();

    // Atualiza a tela com os dados reais
    setState(() {
      _nomeUsuario =
          config.nomeUsuario.isNotEmpty
              ? config.nomeUsuario
              : "Usuário Anônimo";
      _alturaUsuario =
          config.alturaUsuario > 0
              ? "Altura: ${config.alturaUsuario}m"
              : "Configure seu perfil";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            currentAccountPicture: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text("Câmera"),
                          onTap: () => Navigator.pop(context),
                        ),
                        ListTile(
                          leading: const Icon(Icons.photo),
                          title: const Text("Galeria"),
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    );
                  },
                );
              },
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            // 🔥 CORREÇÃO: Variáveis dinâmicas no lugar de textos engessados!
            accountName: Text(
              _nomeUsuario,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(_alturaUsuario),
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConfiguracoesPage(),
                ),
              );
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Dashboard'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DashboardPage()),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
