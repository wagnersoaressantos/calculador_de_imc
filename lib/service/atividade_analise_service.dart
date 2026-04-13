import 'package:calculadora_imc/model/pessoa_model.dart';

class AtividadeAnaliseService {

  // 🔹 Descobre qual atividade mais aparece
  String atividadeMaisFrequente(PessoaModel pessoa) {
    if (pessoa.atividades.isEmpty) {
      return "Sem atividades registradas";
    }

    Map<String, int> contagem = {};

    // 🔹 Conta quantas vezes cada atividade aparece
    for (var atividade in pessoa.atividades) {
      contagem[atividade.tipo] = (contagem[atividade.tipo] ?? 0) + 1;
    }

    // 🔹 Descobre a mais frequente
    String maisFrequente = contagem.keys.first;

    contagem.forEach((tipo, quantidade) {
      if (quantidade > contagem[maisFrequente]!) {
        maisFrequente = tipo;
      }
    });

    return "🏃 Atividade mais frequente: $maisFrequente";
  }

  // 🔹 Verifica se o IMC melhora após atividades
  String impactoNoImc(PessoaModel pessoa) {
    if (pessoa.registros.length < 2 || pessoa.atividades.isEmpty) {
      return "Dados insuficientes para análise";
    }

    double primeiro = pessoa.registros.first.imc;
    double ultimo = pessoa.registros.last.imc;

    if (ultimo < primeiro) {
      return "📉 Suas atividades estão ajudando a reduzir o IMC!";
    } else if (ultimo > primeiro) {
      return "⚠️ Mesmo com atividades, o IMC aumentou";
    } else {
      return "➡️ Atividades sem impacto significativo";
    }
  }

  // 🔹 Insight combinado
  String gerarInsightCompleto(PessoaModel pessoa) {
    if (pessoa.atividades.isEmpty) {
      return "Adicione atividades para gerar insights";
    }

    final frequente = atividadeMaisFrequente(pessoa);
    final impacto = impactoNoImc(pessoa);

    return "$frequente\n$impacto";
  }
}
