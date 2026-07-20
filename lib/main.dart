import 'package:calculadora_imc/app.dart';
import 'package:calculadora_imc/model/atividade_model.dart';
import 'package:calculadora_imc/model/pessoa_model.dart';
import 'package:calculadora_imc/model/registro_imc_model.dart';
import 'package:calculadora_imc/service_locator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inicializa o banco de dados
  await Hive.initFlutter();

  // 2. Registar os adaptadores
  Hive.registerAdapter(RegistroImcModelAdapter());
  Hive.registerAdapter(AtividadeModelAdapter());
  Hive.registerAdapter(PessoaModelAdapter());

  // 🔥 CORREÇÃO: Abrir a caixa com o nome 'pessoasBox'
  // para coincidir com o PessoaRepository!
  await Hive.openBox<PessoaModel>('pessoasBox');
  // Se ainda quiser manter compatibilidade de atividades antigas soltas (opcional)
  await Hive.openBox<AtividadeModel>('atividadesBox');

  // 3. Configura a Injeção de Dependências
  setupLocator();

  // 4. Roda a aplicação
  runApp(const App());
}
