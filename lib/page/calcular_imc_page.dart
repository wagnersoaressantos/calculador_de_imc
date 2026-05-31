import 'package:calculadora_imc/calcularIMC/calculador_de_imc.dart';
import 'package:calculadora_imc/model/configuracao_model.dart';
import 'package:calculadora_imc/repository/configuracoes_repository.dart';
import 'package:calculadora_imc/repository/pessoa_repository.dart';
import 'package:calculadora_imc/share/imagens_share.dart';
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

  final PessoaRepository _repo = PessoaRepository();

  // NOVO: Chave global para identificar e validar o nosso Formulário
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

  /// NOVO: Função para mostrar um SnackBar elegante e flutuante
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
        behavior: SnackBarBehavior.floating, // Faz o SnackBar flutuar
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Bordas arredondadas
        ),
        margin: const EdgeInsets.all(
          16,
        ), // Margem para não ficar colado aos cantos
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.cyan,
          // NOVO: Envolvemos a Column com o Form e passamos a _formKey
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        style: BorderStyle.solid,
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                    child: Image.asset(ImagensShare.imc, height: 75, width: 75),
                  ),
                  const SizedBox(height: 10),

                  // Campo NOME
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        style: BorderStyle.solid,
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                    // Trocamos TextField por TextFormField
                    child: TextFormField(
                      controller: _nomePessoa,
                      decoration: const InputDecoration(hintText: 'Nome'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um nome'; // Mensagem de erro em vermelho
                        }
                        return null; // Null significa que está tudo OK
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Campo PESO
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        style: BorderStyle.solid,
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                    child: TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      controller: _pesoPessoa,
                      decoration: const InputDecoration(
                        hintText: 'Peso (ex: 75.5)',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Insira o peso';
                        // Substitui vírgula por ponto para evitar erros de conversão
                        if (double.tryParse(value.replaceAll(',', '.')) ==
                            null) {
                          return 'Valor inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Campo ALTURA
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        style: BorderStyle.solid,
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                    child: TextFormField(
                      controller: _alturaPessoa,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Altura (m) ex 1.69',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Insira a altura';
                        if (double.tryParse(value.replaceAll(',', '.')) ==
                            null) {
                          return 'Valor inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 8),

                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _alturaPessoa.text =
                            _configuracoesModel.alturaUsuario.toString();
                      });
                    },
                    child: const Text('Usar altura das configurações'),
                  ),
                  const SizedBox(height: 10),

                  if (_exibirResultado)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          style: BorderStyle.solid,
                          width: 2,
                          color: Colors.black,
                        ),
                      ),
                      child: Text(
                        _resultado,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),

                  // Botão CALCULAR
                  ElevatedButton.icon(
                    label: const Text("Calcular"),
                    onPressed: () {
                      // NOVO: Antes de fazer qualquer cálculo, verificamos se o Form é válido
                      if (_formKey.currentState!.validate()) {
                        // Agora é seguro usar o force unwrap (!) porque o validator já garantiu que é um número válido
                        // O replaceAll garante que se o utilizador digitar "70,5" o Dart entende como "70.5"
                        // 1. Pegamos os valores e tratamos a vírgula (que você já tem)
                        double peso = double.parse(
                          _pesoPessoa.text.replaceAll(',', '.'),
                        );
                        double altura = double.parse(
                          _alturaPessoa.text.replaceAll(',', '.'),
                        );

                        // NOVO: 2. Tratamento inteligente para altura em centímetros
                        // Se a altura for maior que 3 (ex: 169, 175, 180), assumimos que está em centímetros!
                        if (altura > 3.0) {
                          altura = altura / 100; // Converte 169 para 1.69
                        }

                        // 3. Verificamos o zero (que você já tem)
                        if (peso == 0 || altura == 0) {
                          _mostrarSnackBar(
                            'Peso e altura não podem ser 0!',
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

                        // Chamamos o nosso novo SnackBar de Sucesso!
                        _mostrarSnackBar(
                          'Registo salvo com sucesso!',
                          Colors.green,
                          Icons.check_circle,
                        );

                        // Opcional: Esconder o teclado do ecrã após calcular
                        FocusScope.of(context).unfocus();
                      } else {
                        // Se falhou a validação, avisamos o utilizador
                        _mostrarSnackBar(
                          'Por favor, corrija os erros nos campos.',
                          Colors.redAccent,
                          Icons.error,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),

                  if (_exibirResultado)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _resultado = "";
                          _exibirResultado = false;
                          _pesoPessoa.text = "";
                          _alturaPessoa.text = "";
                          _nomePessoa.text = "";
                        });
                      },
                      child: const Text('Novo Calculo'),
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
