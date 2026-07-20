import 'package:calculadora_imc/model/pessoa_model.dart';
import 'package:calculadora_imc/model/sessao_usuario.dart';
import 'package:calculadora_imc/repository/pessoa_repository.dart';
import 'package:calculadora_imc/service_locator.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  // Se for nulo, a intenção é criar um utilizador TOTALMENTE novo.
  // Se for enviado um modelo, a intenção é editar esse perfil existente.
  final PessoaModel? pessoaExistente;

  const PerfilPage({super.key, this.pessoaExistente});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final _pessoaRepo = getIt<PessoaRepository>();
  final _sessao = getIt<SessaoUsuario>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _pesoMetaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _objetivoSelecionado = "Manter";
  bool _isEdicao = false;

  @override
  void initState() {
    super.initState();
    _carregarDadosPerfil();
  }

  void _carregarDadosPerfil() {
    // 🔥 CORREÇÃO: Removemos a ligação direta com "_sessao.usuarioAtivo" aqui.
    // Assim garantimos que o botão "Criar Novo Perfil" traga sempre uma página em branco.

    if (widget.pessoaExistente != null) {
      // 💡 MODO EDIÇÃO: Preenchemos os dados do perfil que recebemos
      final pessoa = widget.pessoaExistente!;
      _isEdicao = true;
      _nomeController.text = pessoa.nome;
      _alturaController.text =
          pessoa.alturaPadrao > 0 ? pessoa.alturaPadrao.toString() : "";
      _pesoMetaController.text =
          pessoa.pesoMeta > 0 ? pessoa.pesoMeta.toString() : "";
      _objetivoSelecionado = pessoa.objetivo;
    } else {
      // 💡 MODO CRIAÇÃO: A página fica vazia pronta para um novo utilizador!
      _isEdicao = false;
      _nomeController.clear();
      _alturaController.clear();
      _pesoMetaController.clear();
      _objetivoSelecionado = "Manter";
    }
  }

  void _salvarPerfil() {
    if (_formKey.currentState!.validate()) {
      // Formatação dos dados
      final nome = _nomeController.text.trim();
      final altura =
          double.tryParse(_alturaController.text.replaceAll(',', '.')) ?? 0.0;
      final pesoMeta =
          double.tryParse(_pesoMetaController.text.replaceAll(',', '.')) ?? 0.0;

      // Obtém ou Cria no Hive
      final pessoa = _pessoaRepo.obterOuCriarPessoa(
        nome,
        altura,
        pesoMeta: pesoMeta,
        objetivo: _objetivoSelecionado,
      );

      if (pessoa != null) {
        // Atualiza e guarda
        pessoa.alturaPadrao = altura;
        pessoa.pesoMeta = pesoMeta;
        pessoa.objetivo = _objetivoSelecionado;
        pessoa.save();

        // Atualiza a Sessão
        _sessao.selecionarUsuario(pessoa);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEdicao
                  ? "Perfil atualizado com sucesso!"
                  : "Novo perfil criado!",
            ),
            backgroundColor: Colors.green,
          ),
        );

        FocusScope.of(context).unfocus();
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdicao ? "Editar Perfil" : "Criar Novo Perfil"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isEdicao
                      ? "Atualize as suas informações e metas."
                      : "Crie um novo perfil para guardar as suas atividades separadamente.",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                TextFormField(
                  controller: _nomeController,
                  enabled:
                      !_isEdicao, // Bloqueia a alteração de nomes de perfis que já existem
                  decoration: const InputDecoration(
                    labelText: "Seu Nome (Único)",
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'O nome não pode estar vazio';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _alturaController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Sua Altura Padrão (ex: 1.70)",
                    prefixIcon: Icon(Icons.height),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Informe a altura';
                    if (double.tryParse(value.replaceAll(',', '.')) == null)
                      return 'Valor inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _pesoMetaController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Sua Meta de Peso (kg)",
                    prefixIcon: Icon(Icons.flag),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Informe uma meta (ou 0)';
                    if (double.tryParse(value.replaceAll(',', '.')) == null)
                      return 'Valor inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _objetivoSelecionado,
                  decoration: const InputDecoration(
                    labelText: "Objetivo Principal",
                    prefixIcon: Icon(Icons.track_changes),
                  ),
                  items:
                      ["Emagrecer", "Manter", "Hipertrofia"].map((
                        String objetivo,
                      ) {
                        return DropdownMenuItem(
                          value: objetivo,
                          child: Text(objetivo),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _objetivoSelecionado = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 32),

                ElevatedButton.icon(
                  onPressed: _salvarPerfil,
                  icon: const Icon(Icons.save),
                  label: Text(_isEdicao ? "Atualizar Perfil" : "Criar Perfil"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
