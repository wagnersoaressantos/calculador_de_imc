import 'package:calculadora_imc/model/sessao_usuario.dart';
import 'package:calculadora_imc/page/perfil_page.dart'; // Import corrigido
import 'package:calculadora_imc/service_locator.dart';
import 'package:flutter/material.dart';

class CustonDrawer extends StatefulWidget {
  const CustonDrawer({super.key});

  @override
  State<CustonDrawer> createState() => _CustonDrawerState();
}

class _CustonDrawerState extends State<CustonDrawer> {
  final _sessao = getIt<SessaoUsuario>();

  @override
  void initState() {
    super.initState();
    _sessao.addListener(_atualizarDrawer);
  }

  @override
  void dispose() {
    _sessao.removeListener(_atualizarDrawer);
    super.dispose();
  }

  void _atualizarDrawer() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final usuarioAtivo = _sessao.usuarioAtivo;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              child: Text(
                usuarioAtivo != null && usuarioAtivo.nome.isNotEmpty
                    ? usuarioAtivo.nome[0].toUpperCase()
                    : "?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            accountName: Text(
              usuarioAtivo != null ? usuarioAtivo.nome : "Selecione um Perfil",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(
              usuarioAtivo != null && usuarioAtivo.alturaPadrao > 0
                  ? "Altura Padrão: ${usuarioAtivo.alturaPadrao}m"
                  : "Crie ou selecione um perfil",
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text("Meu Perfil & Metas"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pop(context);
              if (usuarioAtivo != null) {
                // 🔥 CORREÇÃO PRINCIPAL AQUI:
                // Estamos a passar o "usuarioAtivo" para a PerfilPage.
                // Isto avisa a página que não é para criar um novo, mas sim editar!
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PerfilPage(pessoaExistente: usuarioAtivo),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor, crie um perfil primeiro.'),
                  ),
                );
              }
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
