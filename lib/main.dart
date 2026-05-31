// import 'package:calculadora_imc/calcularIMC/calculador_de_imc.dart';
import 'package:calculadora_imc/app.dart';
import 'package:calculadora_imc/model/atividade_model.dart';
import 'package:calculadora_imc/model/pessoa_model.dart';
import 'package:calculadora_imc/model/registro_imc_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(RegistroImcModelAdapter());
  Hive.registerAdapter(AtividadeModelAdapter());
  Hive.registerAdapter(PessoaModelAdapter());

  await Hive.openBox<PessoaModel>('pessoas');

  runApp(App());
}
