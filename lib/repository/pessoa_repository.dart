import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart'; // Necessário para o debugPrint
import '../model/pessoa_model.dart';
import '../model/registro_imc_model.dart';

class PessoaRepository {
  // Pegamos a box, mas vamos ter cuidado ao manipulá-la!
  final Box<PessoaModel> _box = Hive.box<PessoaModel>('pessoas');

  // 🔹 Criar ou buscar pessoa (Com tratamento de erro)
  PessoaModel? obterOuCriarPessoa(String nome, double altura) {
    // 1ª Camada de Segurança: A caixa está aberta?
    if (!_box.isOpen) {
      debugPrint("ERRO: A box do Hive está fechada!");
      return null;
    }

    try {
      final pessoa = _box.values.firstWhere(
        (p) => p.nome == nome,
        orElse: () {
          final novaPessoa = PessoaModel(
            nome: nome,
            altura: altura,
            registros: [],
            atividades: [],
          );
          // 2ª Camada: Tenta adicionar. Se a memória estiver cheia, o catch apanha.
          _box.add(novaPessoa);
          return novaPessoa;
        },
      );
      return pessoa;
    } catch (e) {
      debugPrint("ERRO ao obter ou criar pessoa: $e");
      return null;
    }
  }

  // 🔹 Adicionar IMC corretamente (Com tratamento de erro)
  bool adicionarRegistro({
    required String nome,
    required double peso,
    required double altura,
  }) {
    try {
      final pessoa = obterOuCriarPessoa(nome, altura);

      // Se deu erro ao buscar a pessoa, cancelamos a gravação e avisamos a UI (retornando false)
      if (pessoa == null) return false;

      final imc = peso / (altura * altura);

      final registro = RegistroImcModel(
        peso: peso,
        altura: altura,
        imc: imc,
        data: DateTime.now(),
      );

      pessoa.registros.add(registro);

      // Salva no banco. Pode falhar se houver corrupção de dados ou falta de espaço
      pessoa.save();

      return true; // Sucesso absoluto!
    } catch (e) {
      debugPrint("ERRO Crítico ao tentar gravar o registro de IMC: $e");
      return false; // Retornamos falso em vez de fechar a aplicação
    }
  }

  // 🔹 Listar pessoas (Com segurança)
  List<PessoaModel> listarPessoas() {
    if (!_box.isOpen)
      return []; // Retorna lista vazia se a box estiver inacessível

    try {
      return _box.values.toList();
    } catch (e) {
      debugPrint("ERRO ao listar pessoas: $e");
      return []; // Protege a UI devolvendo uma lista vazia em vez de quebrar a tela
    }
  }

  // 🔹 Buscar por nome
  PessoaModel? buscarPorNome(String nome) {
    if (!_box.isOpen) return null;

    try {
      return _box.values.firstWhere((p) => p.nome == nome);
    } catch (e) {
      // O firstWhere lança erro se não encontrar ninguém.
      // O catch captura isso pacificamente.
      debugPrint("Pessoa não encontrada ou erro na busca: $e");
      return null;
    }
  }
}
