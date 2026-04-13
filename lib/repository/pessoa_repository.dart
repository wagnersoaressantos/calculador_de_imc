import 'package:hive/hive.dart';
import '../model/pessoa_model.dart';
import '../model/registro_imc_model.dart';

class PessoaRepository {
  final Box<PessoaModel> _box = Hive.box<PessoaModel>('pessoas');

  // 🔹 Criar ou buscar pessoa
  PessoaModel obterOuCriarPessoa(String nome, double altura) {
    final pessoa = _box.values.firstWhere(
      (p) => p.nome == nome,
      orElse: () {
        final novaPessoa = PessoaModel(
          nome: nome,
          altura: altura,
          registros: [],
          atividades: [],
        );
        _box.add(novaPessoa);
        return novaPessoa;
      },
    );

    return pessoa;
  }

  // 🔹 Adicionar IMC corretamente
  void adicionarRegistro({
    required String nome,
    required double peso,
    required double altura,
  }) {
    final pessoa = obterOuCriarPessoa(nome, altura);

    final imc = peso / (altura * altura);

    final registro = RegistroImcModel(
      peso: peso,
      altura: altura,
      imc: imc,
      data: DateTime.now(),
    );

    pessoa.registros.add(registro);
    pessoa.save();
  }

  // 🔹 Listar pessoas
  List<PessoaModel> listarPessoas() {
    return _box.values.toList();
  }

  // 🔹 Buscar por nome
  PessoaModel? buscarPorNome(String nome) {
    try {
      return _box.values.firstWhere((p) => p.nome == nome);
    } catch (e) {
      return null;
    }
  }
}
