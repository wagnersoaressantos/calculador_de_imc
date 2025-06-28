import 'package:calculadora_imc/calcularIMC/calculador_de_imc.dart';
import 'package:calculadora_imc/model/configuracao_model.dart';
import 'package:calculadora_imc/model/pessoa_model.dart';
import 'package:calculadora_imc/repository/configuracoes_repository.dart';
import 'package:calculadora_imc/repository/imc_repository.dart';
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
  final ImcRepository _repo = ImcRepository();
  @override
  void initState() {
    super.initState();
    _carregarConfiguracoes();
  }

  void _carregarConfiguracoes() async {
    _configuracoesRepository = await ConfiguracoesRepository.load();
    _configuracoesModel = _configuracoesRepository.pegarDados();

    // Você pode preencher o nome por padrão também, se quiser
    setState(() {
      _nomePessoa.text = _configuracoesModel.nomeUsuario;
    });
  }

  String _resultado = "";
  bool _exibirResultado = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(title: Text('Calculadora de IMC'), centerTitle: true),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          color: Colors.cyan,
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // container da image
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      style: BorderStyle.solid,
                      width: 2,
                      color: Colors.black,
                    ),
                  ),
                  child: Column(
                    children: [
                      Image.asset(ImagensShare.imc, height: 75, width: 75),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      style: BorderStyle.solid,
                      width: 2,
                      color: Colors.black,
                    ),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nomePessoa,
                        decoration: InputDecoration(hintText: 'Nome'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      style: BorderStyle.solid,
                      width: 2,
                      color: Colors.black,
                    ),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _pesoPessoa,
                        decoration: InputDecoration(hintText: 'Peso (ex: 75)'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      style: BorderStyle.solid,
                      width: 2,
                      color: Colors.black,
                    ),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _alturaPessoa,
                        decoration: InputDecoration(
                          hintText: 'Altura (m) ex 1.69',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _alturaPessoa.text =
                          _configuracoesModel.alturaUsuario.toString();
                    });
                  },
                  child: Text('Usar altura das configurações'),
                ),
                SizedBox(height: 10),
                if (_exibirResultado)
                  Container(
                    padding: EdgeInsets.all(16),
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_pesoPessoa.text.isEmpty ||
                        _alturaPessoa.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Preencha todos os campos!')),
                      );
                      return;
                    }
                    if (_pesoPessoa.text == '0' || _alturaPessoa.text == '0') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Peso e altura não podem ser 0!'),
                        ),
                      );
                      return;
                    }
                    setState(() {
                      _resultado = CalculadorDeImc.calculadorDeImc(
                        double.tryParse(_pesoPessoa.text)!,
                        double.tryParse(_alturaPessoa.text)!,
                      );
                      PessoaModel pessoa = PessoaModel(_nomePessoa.text);
                      _repo.addImc(pessoa.nome, _resultado);
                      _exibirResultado = true;
                    });
                  },
                  child: Text('Calcular'),
                ),
                SizedBox(height: 2),
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
                    child: Text('Novo Calculo'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
