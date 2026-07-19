import 'package:calculadora_imc/repository/pessoa_repository.dart';
import 'package:calculadora_imc/model/sessao_usuario.dart'; // Importa o novo ficheiro
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<PessoaRepository>(PessoaRepository());

  // 🔥 Regista a sessão para que possamos aceder a ela em qualquer página!
  getIt.registerSingleton<SessaoUsuario>(SessaoUsuario());
}
