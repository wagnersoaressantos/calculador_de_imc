import 'package:calculadora_imc/model/guardar_imc_model.dart';
import 'package:calculadora_imc/page/calcular_imc_page.dart';
import 'package:calculadora_imc/repository/imc_repository.dart';
import 'package:flutter/material.dart';

class HistoricoImcPage extends StatefulWidget {
  const HistoricoImcPage({super.key});

  @override
  State<HistoricoImcPage> createState() => _HistoricoImcPageState();
}

class _HistoricoImcPageState extends State<HistoricoImcPage> {
  final ImcRepository _repo = ImcRepository();
  List<GuardarImcModel> _listaImc = [];

  @override
  void initState() {
    super.initState();
    _listaImc = _repo.getImcList();
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
            _listaImc = _repo.getImcList();
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
          _listaImc.isEmpty
              ? Center(child: Text("Nenhum histórico encontrado."))
              : ListView.builder(
                itemCount: _listaImc.length,
                itemBuilder: (_, index) {
                  final pessoa = _listaImc[index];
                  return Card(
                    child: ListTile(
                      title: Text(pessoa.nome),
                      subtitle: Text("IMCs: ${pessoa.imc.join(', ')}"),
                    ),
                  );
                },
              ),
    );
  }
}
