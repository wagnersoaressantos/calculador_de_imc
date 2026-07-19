import 'package:calculadora_imc/calcularIMC/calculador_de_imc.dart';
import 'package:calculadora_imc/model/configuracao_model.dart';
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
  late ConfiguracoesRepository _configuracoesRepository;
  late ConfiguracoesModel _configuracoesModel;

  final TextEditingController _nomePessoa = TextEditingController();
  final TextEditingController _pesoPessoa = TextEditingController();
  final TextEditingController _alturaPessoa = TextEditingController();

  final _repo = getIt<PessoaRepository>();
  final _formKey = GlobalKey<FormState>();

  String _resultado = "";
  bool _exibirResultado = false;

  @override
  void initState() {
    super.initState();
    _carregarConfiguracoes();
  }

  void _carregarConfiguracoes() async {
    _configuracoesRepository = await ConfiguracoesRepository.load();
    _configuracoesModel = _configuracoesRepository.pegarDados();

    setState(() {
      _nomePessoa.text = _configuracoesModel.nomeUsuario;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔥 O fundo ciano foi removido. O Scaffold agora usa a cor de fundo do Tema (Claro ou Escuro)!
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            // 🔥 2. Dar um pouco mais de "respiro" no fundo (bottom: 40) para o botão não ficar colado à base
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 24.0,
              bottom: 40.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, // Estica os botões
                children: [
                  // 🔥 O nosso "Logo" dinâmico usando ícone
                  Icon(
                    Icons.calculate,
                    size: 100,
                    color:
                        Theme.of(
                          context,
                        ).colorScheme.primary, // Usa a cor principal do tema
                  ),
                  const SizedBox(height: 30),

                  // 🔥 Campo NOME super limpo (o tema trata das bordas)
                  TextFormField(
                    controller: _nomePessoa,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      prefixIcon: Icon(
                        Icons.person,
                      ), // Um ícone elegante dentro do campo
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um nome';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 🔥 Campo PESO
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    controller: _pesoPessoa,
                    decoration: const InputDecoration(
                      labelText: 'Peso (ex: 75.5 kg)',
                      prefixIcon: Icon(Icons.monitor_weight),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Insira o peso';
                      if (double.tryParse(value.replaceAll(',', '.')) == null) {
                        return 'Valor inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 🔥 Campo ALTURA
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
                      if (value == null || value.isEmpty)
                        return 'Insira a altura';
                      if (double.tryParse(value.replaceAll(',', '.')) == null) {
                        return 'Valor inválido';
                      }
                      return null;
                    },
                  ),

                  // Botão subtil em formato de texto para puxar a altura
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      icon: const Icon(Icons.settings, size: 16),
                      label: const Text('Usar altura do perfil'),
                      onPressed: () {
                        setState(() {
                          _alturaPessoa.text =
                              _configuracoesModel.alturaUsuario.toString();
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🔥 CARTÃO DE RESULTADO DINÂMICO
                  if (_exibirResultado)
                    Card(
                      color:
                          Theme.of(context)
                              .colorScheme
                              .primaryContainer, // Azul claro ou azul escuro, consoante o tema
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
                                Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer, // Texto adaptável ao fundo!
                          ),
                        ),
                      ),
                    ),

                  // 🔥 Botão CALCULAR
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text("Calcular e Guardar"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // 1. TRATAMENTO DE STRINGS E VÍRGULAS
                        // O .replaceAll(',', '.') garante que a vírgula vire ponto,
                        // pois a linguagem Dart só faz contas com ponto decimal.
                        // O .trim() remove os espaços invisíveis no início ou fim.
                        double peso = double.parse(
                          _pesoPessoa.text.replaceAll(',', '.').trim(),
                        );
                        double altura = double.parse(
                          _alturaPessoa.text.replaceAll(',', '.').trim(),
                        );

                        if (altura > 3.0) altura = altura / 100;

                        if (peso == 0 || altura == 0) {
                          _mostrarSnackBar(
                            'Peso e altura não podem ser 0!',
                            Colors.orange,
                            Icons.warning,
                          );
                          return;
                        }
                        // 2. PREVENÇÃO DE ERROS: DADOS IRREAIS
                        // Bloqueia se o usuário digitar dados absurdos por engano.
                        // Ajustado para permitir bebês: peso mínimo 1kg e altura mínima 0.25m (25cm).
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

                        setState(() {
                          _resultado = CalculadorDeImc.calculadorDeImc(
                            peso,
                            altura,
                          );
                          _repo.adicionarRegistro(
                            nome: _nomePessoa.text,
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

                        // 3. LIMPEZA DOS CAMPOS
                        // Limpamos o peso automaticamente para facilitar um novo cadastro,
                        // e tiramos o foco para fechar o teclado do celular.
                        _pesoPessoa.clear();
                        FocusScope.of(context).unfocus();
                      } else {
                        _mostrarSnackBar(
                          'Por favor, corrija os erros nos campos.',
                          Colors.redAccent,
                          Icons.error,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor:
                          Theme.of(
                            context,
                          ).colorScheme.primary, // Cor do botão do tema
                      foregroundColor:
                          Theme.of(
                            context,
                          ).colorScheme.onPrimary, // Cor do texto do botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Botão NOVO CÁLCULO
                  if (_exibirResultado)
                    OutlinedButton.icon(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        setState(() {
                          _resultado = "";
                          _exibirResultado = false;
                          _pesoPessoa.text = "";
                          _alturaPessoa.text = "";
                          _nomePessoa.text = "";
                        });
                      },
                      label: const Text('Novo Calculo'),
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
      ),
    );
  }
}
