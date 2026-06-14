import 'package:calculadora_imc/model/configuracao_model.dart';
import 'package:calculadora_imc/repository/configuracoes_repository.dart';
import 'package:flutter/material.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  late ConfiguracoesRepository configuracoesRepository;
  var configuracoesModel = ConfiguracoesModel.vazio();

  final TextEditingController nomeUsuarioController = TextEditingController();
  final TextEditingController alturaUsuarioController = TextEditingController();
  final TextEditingController pesoMetaController =
      TextEditingController(); // Novo

  String _objetivoSelecionado = "Manter"; // Novo

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  void carregarDados() async {
    configuracoesRepository = await ConfiguracoesRepository.load();
    configuracoesModel = configuracoesRepository.pegarDados();

    nomeUsuarioController.text = configuracoesModel.nomeUsuario;
    alturaUsuarioController.text = configuracoesModel.alturaUsuario.toString();
    pesoMetaController.text = configuracoesModel.pesoMeta.toString();
    _objetivoSelecionado = configuracoesModel.objetivo;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Configurações")),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                controller: nomeUsuarioController,
                decoration: const InputDecoration(
                  labelText: "Nome de Utilizador",
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: alturaUsuarioController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Altura (ex: 1.70)"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: pesoMetaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Peso Meta (kg)"),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _objetivoSelecionado,
                decoration: const InputDecoration(labelText: "Objetivo"),
                items:
                    ["Emagrecer", "Hipertrofia", "Manter"]
                        .map(
                          (obj) => DropdownMenuItem(value: obj, child: Text(obj)),
                        )
                        .toList(),
                onChanged:
                    (value) => setState(() => _objetivoSelecionado = value!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  try {
                    configuracoesModel.alturaUsuario = double.parse(
                      alturaUsuarioController.text,
                    );
                    configuracoesModel.pesoMeta = double.parse(
                      pesoMetaController.text,
                    );
                    configuracoesModel.nomeUsuario = nomeUsuarioController.text;
                    configuracoesModel.objetivo = _objetivoSelecionado;
          
                    configuracoesRepository.salvar(configuracoesModel);
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Erro: Verifique os números inseridos!"),
                      ),
                    );
                  }
                },
                child: const Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
