import 'package:calculadora_imc/calcularIMC/calculador_de_imc.dart';
import 'package:calculadora_imc/model/configuracao_model.dart';
import 'package:calculadora_imc/model/sessao_usuario.dart';
import 'package:calculadora_imc/repository/configuracoes_repository.dart';
import 'package:calculadora_imc/repository/pessoa_repository.dart';
import 'package:calculadora_imc/service_locator.dart';
import 'package:flutter/material.dart';

class CalcularImcPage extends StatefulWidget {
  const CalcularImcPage({super.key});

  @override
  State<CalcularImcPage> createState() => _CalcularImcPageState();
}

class _CalcularImcPageState extends State<CalcularImcPage> {
  // --------------------------------------------------------
  // DEPENDÊNCIAS E REPOSITÓRIOS
  // --------------------------------------------------------
  late ConfiguracoesRepository _configuracoesRepository;
  ConfiguracoesModel _configuracaoModel = ConfiguracoesModel.vazio();
  final _repo = getIt<PessoaRepository>();
  final _sessao = getIt<SessaoUsuario>(); // O nosso gestor de sessão

  // --------------------------------------------------------
  // CONTROLADORES E ESTADO
  // --------------------------------------------------------
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomePessoa = TextEditingController();
  final TextEditingController _pesoPessoa = TextEditingController();
  final TextEditingController _alturaPessoa = TextEditingController();

  String _resultado = "";
  bool _exibirResultado = false;

  // --------------------------------------------------------
  // CICLO DE VIDA (LIFECYCLE)
  // --------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _carregarDadosIniciais();
  }

  @override
  void dispose() {
    // É boa prática libertar os controladores quando a página é destruída
    _nomePessoa.dispose();
    _pesoPessoa.dispose();
    _alturaPessoa.dispose();
    super.dispose();
  }

  // --------------------------------------------------------
  // MÉTODOS DE LÓGICA DE NEGÓCIO
  // --------------------------------------------------------
  Future<void> _carregarDadosIniciais() async {
    _configuracoesRepository = await ConfiguracoesRepository.load();
    _configuracaoModel = _configuracoesRepository.pegarDados();

    setState(() {
      // 1. Verifica se há um perfil selecionado na Sessão
      if (_sessao.usuarioAtivo != null) {
        _nomePessoa.text = _sessao.usuarioAtivo!.nome;
      } else {
        // Se não houver sessão ativa, usa a configuração padrão global
        _nomePessoa.text = _configuracaoModel.nomeUsuario;
      }

      // 2. Pré-preenche a altura se existir
      if (_configuracaoModel.alturaUsuario > 0) {
        _alturaPessoa.text = _configuracaoModel.alturaUsuario.toString();
      }
    });
  }

  void _mostrarSnackBar(String mensagem, Color cor, IconData icone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icone, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                mensagem,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: cor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _calcularEGuardar() {
    if (!_formKey.currentState!.validate()) {
      _mostrarSnackBar(
        'Por favor, corrija os erros nos campos.',
        Colors.redAccent,
        Icons.error,
      );
      return;
    }

    // Tratamento de Strings e conversão de vírgula para ponto
    String pesoTexto = _pesoPessoa.text.replaceAll(',', '.').trim();
    String alturaTexto = _alturaPessoa.text.replaceAll(',', '.').trim();

    double peso = double.parse(pesoTexto);
    double altura = double.parse(alturaTexto);

    // Ajuste de escala para altura digitada em centímetros (ex: 170)
    if (altura > 3.0) altura = altura / 100;

    // Prevenção de Erros: Dados irreais
    if (peso < 1.0 || peso > 500.0) {
      _mostrarSnackBar(
        'Insira um peso realista (entre 1kg e 500kg).',
        Colors.orange,
        Icons.warning,
      );
      return;
    }

    if (altura < 0.25 || altura > 3.0) {
      _mostrarSnackBar(
        'Insira uma altura realista (entre 0.25m e 3.0m).',
        Colors.orange,
        Icons.warning,
      );
      return;
    }

    // Calcula e Grava
    setState(() {
      _resultado = CalculadorDeImc.calculadorDeImc(peso, altura);

      _repo.adicionarRegistro(
        nome: _nomePessoa.text.trim(),
        peso: peso,
        altura: altura,
      );

      _exibirResultado = true;
    });

    _mostrarSnackBar(
      'Registo salvo com sucesso!',
      Colors.green,
      Icons.check_circle,
    );

    // Limpeza de campos para UX fluida
    _pesoPessoa.clear();
    FocusScope.of(context).unfocus(); // Fecha o teclado
  }

  void _novoCalculo() {
    setState(() {
      _resultado = "";
      _exibirResultado = false;
      _pesoPessoa.clear();
      // Não apagamos o nome e a altura para facilitar medições recorrentes
    });
  }

  // --------------------------------------------------------
  // INTERFACE DE UTILIZADOR (BUILD)
  // --------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // Verifica se pode voltar atrás (se foi chamada por push ou está numa aba)
    final bool mostrarAppBar = Navigator.canPop(context);

    return Scaffold(
      appBar:
          mostrarAppBar
              ? AppBar(title: const Text('Calculadora de IMC'))
              : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 24.0,
            bottom: 40.0, // Respiro inferior para o botão
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ícone ilustrativo no topo
                Icon(
                  Icons.calculate,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 30),

                // Campo: Nome
                TextFormField(
                  controller: _nomePessoa,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Perfil',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, insira um nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo: Peso
                TextFormField(
                  controller: _pesoPessoa,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Peso (ex: 75.5 kg)',
                    prefixIcon: Icon(Icons.monitor_weight),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Insira o peso';
                    }
                    if (double.tryParse(value.replaceAll(',', '.')) == null) {
                      return 'Valor inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo: Altura
                TextFormField(
                  controller: _alturaPessoa,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Altura (ex: 1.69 m)',
                    prefixIcon: Icon(Icons.height),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Insira a altura';
                    }
                    if (double.tryParse(value.replaceAll(',', '.')) == null) {
                      return 'Valor inválido';
                    }
                    return null;
                  },
                ),

                // Botão de atalho: Usar Altura do Perfil Global
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.settings_backup_restore, size: 16),
                    label: const Text('Usar altura padrão'),
                    onPressed: () {
                      if (_configuracaoModel.alturaUsuario > 0) {
                        setState(() {
                          _alturaPessoa.text =
                              _configuracaoModel.alturaUsuario.toString();
                        });
                        _mostrarSnackBar(
                          "Altura restaurada",
                          Colors.blue,
                          Icons.info,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Cartão Dinâmico de Resultados
                if (_exibirResultado)
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        _resultado,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),

                // Botão de Submissão Principal
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text("Calcular e Guardar"),
                  onPressed: _calcularEGuardar,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Botão Secundário: Novo Cálculo
                if (_exibirResultado)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Novo Cálculo'),
                    onPressed: _novoCalculo,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
