import 'package:get_it/get_it.dart';
import 'package:calculadora_imc/repository/pessoa_repository.dart';

// O 'GetIt.I' é a nossa caixa de ferramentas global!
final getIt = GetIt.instance;

void configurarInjecaoDependencias() {
  // Dizemos à caixa de ferramentas para criar e guardar UMA ÚNICA cópia do repositório (Singleton)
  getIt.registerLazySingleton<PessoaRepository>(() => PessoaRepository());
}