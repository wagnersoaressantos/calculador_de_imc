import 'package:calculadora_imc/app.dart';
import 'package:calculadora_imc/model/atividade_model.dart';
import 'package:calculadora_imc/model/pessoa_model.dart';
import 'package:calculadora_imc/model/registro_imc_model.dart';
import 'package:calculadora_imc/service_locator.dart'; // NOVO IMPORT
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inicializa o banco de dados
  await Hive.initFlutter();

  Hive.registerAdapter(RegistroImcModelAdapter());
  Hive.registerAdapter(AtividadeModelAdapter());
  Hive.registerAdapter(PessoaModelAdapter());

  await Hive.openBox<PessoaModel>('pessoas');

  // NOVO: 2. Configura a nossa Injeção de Dependências ANTES de abrir a App
  configurarInjecaoDependencias();

  // 3. Roda a aplicação
  runApp(const App());
}