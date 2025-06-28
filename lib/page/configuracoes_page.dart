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

  TextEditingController nomeUsuarioController = TextEditingController();
  TextEditingController alturaUsuarioController = TextEditingController();

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Cofigurações Hive")),
        body: Container(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(hintText: "Nome de usuario"),
                  controller: nomeUsuarioController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "Altura"),
                  controller: alturaUsuarioController,
                ),
              ),
              // SwitchListTile(
              //   title: Text("Receber notificações"),
              //   value: configuracoesModel.notificacarUsuario,
              //   onChanged: (bool value) {
              //     setState(() {
              //       configuracoesModel.notificacarUsuario = value;
              //     });
              //   },
              // ),
              // SwitchListTile(
              //   title: Text("Tema escuro"),
              //   value: configuracoesModel.temaEscuro,
              //   onChanged: (bool value) {
              //     setState(() {
              //       configuracoesModel.temaEscuro = value;
              //     });
              //   },
              // ),
              TextButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  try {
                    configuracoesModel.alturaUsuario = double.parse(
                      alturaUsuarioController.text,
                    );
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Meu App"),
                          content: Text(
                            "Por favor informar uma altura valida em metro ex.: 1.68",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('ok'),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }
                  configuracoesModel.nomeUsuario = nomeUsuarioController.text;
                  configuracoesRepository.salvar(configuracoesModel);
                  Navigator.pop(context);
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}