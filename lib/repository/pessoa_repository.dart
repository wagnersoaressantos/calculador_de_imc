import 'package:calculadora_imc/model/pessoa_model.dart';
import 'package:calculadora_imc/model/registro_imc_model.dart';
import 'package:hive/hive.dart';

class PessoaRepository {
  static const String boxName = 'pessoasBox';

  List<PessoaModel> listarPessoas() {
    var box = Hive.box<PessoaModel>(boxName);
    return box.values.toList();
  }

  // Modificado para aceitar os novos campos opcionais
  PessoaModel? obterOuCriarPessoa(
    String nome,
    double alturaAtual, {
    double pesoMeta = 0.0,
    String objetivo = "Manter",
  }) {
    var box = Hive.box<PessoaModel>(boxName);
    PessoaModel? pessoa;

    try {
      pessoa = box.values.firstWhere(
        (p) => p.nome.toLowerCase() == nome.toLowerCase(),
      );
      // Se a pessoa já existe, não sobrecrevemos as metas e altura padrão aqui,
      // a menos que estejamos explicitamente a atualizá-la noutro lado.
    } catch (e) {
      // Se não existir, criamos a pessoa com os novos campos
      pessoa = PessoaModel(
        nome: nome,
        registros: [],
        alturaPadrao: alturaAtual,
        pesoMeta: pesoMeta,
        objetivo: objetivo,
      );
      box.add(pessoa);
    }
    return pessoa;
  }

  void adicionarRegistro({
    required String nome,
    required double peso,
    required double altura,
  }) {
    var box = Hive.box<PessoaModel>(boxName);
    var pessoa = obterOuCriarPessoa(nome, altura);

    if (pessoa != null) {
      var registro = RegistroImcModel(
        peso: peso,
        altura: altura,
        imc: peso / (altura * altura),
        data: DateTime.now(),
      );
      pessoa.registros.add(registro);
      // Atualizamos também a altura padrão para a última altura medida (opcional, mas bom para UX)
      pessoa.alturaPadrao = altura;
      pessoa.save();
    }
  }

  void atualizarPessoa(PessoaModel pessoa) {
    pessoa.save();
  }

  void removerPessoa(String nome) {
    var box = Hive.box<PessoaModel>(boxName);
    try {
      var pessoa = box.values.firstWhere(
        (p) => p.nome.toLowerCase() == nome.toLowerCase(),
      );
      pessoa.delete();
    } catch (e) {
      // Pessoa não encontrada
    }
  }
}
