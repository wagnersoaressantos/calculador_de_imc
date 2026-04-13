import 'package:calculadora_imc/calcularIMC/calculador_de_imc.dart';
import 'package:calculadora_imc/model/pessoa_model.dart';
import 'package:calculadora_imc/page/calcular_imc_page.dart';
import 'package:calculadora_imc/repository/pessoa_repository.dart';
import 'package:flutter/material.dart';

class HistoricoImcPage extends StatefulWidget {
  const HistoricoImcPage({super.key});

  @override
  State<HistoricoImcPage> createState() => _HistoricoImcPageState();
}

class _HistoricoImcPageState extends State<HistoricoImcPage> {
  final PessoaRepository _repo = PessoaRepository();
  List<PessoaModel> _listaPessoas = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    _listaPessoas = _repo.listarPessoas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Histórico de IMC")),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CalcularImcPage()),
          );
          setState(() {
            _carregarDados();
          });
        },
        // onPressed: () async {
        //   await Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const CalcularImcPage()),
        //   );
        //   setState(() {
        //     _listaImc = _repo.getImcList();
        //   });
        // },
      ),
      body:
          _listaPessoas.isEmpty
              ? Center(child: Text("Nenhum histórico encontrado."))
              : ListView.builder(
                itemCount: _listaPessoas.length,
                itemBuilder: (_, index) {
                  final pessoa = _listaPessoas[index];
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ExpansionTile(
                      title: Text(
                        pessoa.nome,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      children:
                          pessoa.registros.isEmpty
                              ? [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Nenhum registro ainda."),
                                ),
                              ]
                              : pessoa.registros.map((registro) {
                                return ListTile(
                                  title: Text(
                                    "IMC: ${registro.imc.toStringAsFixed(2)}",
                                  ),
                                  subtitle: Text(
                                    "Peso: ${registro.peso} kg\n"
                                    "Classificação: ${CalculadorDeImc().classificacaoIMC(registro.imc)} \n"
                                    "Data: ${registro.data.day}/${registro.data.month}/${registro.data.year}",
                                  ),
                                );
                              }).toList(), // subtitle: Text("IMCs: ${pessoa.imc.join(', ')}"),
                    ),
                  );
                },
              ),
    );
  }
}
