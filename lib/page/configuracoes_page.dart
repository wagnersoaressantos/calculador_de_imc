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
  ConfiguracoesModel configuracoesModel = ConfiguracoesModel.vazio();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _pesoMetaController = TextEditingController();

  // 🔥 CORREÇÃO: Adicionada a _formKey que estava a faltar
  final _formKey = GlobalKey<FormState>();

  String _objetivoSelecionado = "Manter";

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() async {
    configuracoesRepository = await ConfiguracoesRepository.load();
    configuracoesModel = configuracoesRepository.pegarDados();

    setState(() {
      _nomeController.text = configuracoesModel.nomeUsuario;
      _alturaController.text = configuracoesModel.alturaUsuario.toString();
      _pesoMetaController.text = configuracoesModel.pesoMeta.toString();
      _objetivoSelecionado = configuracoesModel.objetivo;
    });
  }

  void _salvarConfiguracoes() {
    // Validação usando o FormKey
    if (_formKey.currentState!.validate()) {
      // Usar trim para limpar espaços como pedimos nos outros campos
      configuracoesModel.nomeUsuario = _nomeController.text.trim();
      configuracoesModel.alturaUsuario = double.parse(
        _alturaController.text.replaceAll(',', '.'),
      );
      configuracoesModel.pesoMeta = double.parse(
        _pesoMetaController.text.replaceAll(',', '.'),
      );
      configuracoesModel.objetivo = _objetivoSelecionado;

      configuracoesRepository.salvar(configuracoesModel);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Métricas e Metas atualizadas com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );

      // Fecha o teclado
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔥 Título atualizado
      appBar: AppBar(title: const Text("Meu Perfil & Metas")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey, // 🔥 O Form usa a chave aqui
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🔥 Cabeçalho explicativo adicionado
                const Text(
                  "Configure aqui as suas informações pessoais e os seus objetivos de saúde. Estes dados serão usados como padrão nos seus novos cálculos.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: "Seu Nome Padrão",
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'O nome não pode estar vazio';
                    }
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
                    labelText: "Altura Padrão (ex: 1.70)",
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
                    labelText: "Qual é a sua Meta de Peso? (kg)",
                    prefixIcon: Icon(Icons.flag),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Informe uma meta (ou 0 para ignorar)';
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
                  onPressed: _salvarConfiguracoes,
                  icon: const Icon(Icons.save),
                  label: const Text("Salvar Perfil"),
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
