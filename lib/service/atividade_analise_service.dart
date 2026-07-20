import 'package:calculadora_imc/model/pessoa_model.dart';

class AtividadeAnaliseService {
  // 🔹 Descobre qual atividade mais aparece na lista do utilizador
  String atividadeMaisFrequente(PessoaModel pessoa) {
    if (pessoa.atividades.isEmpty) {
      return "Sem atividades registadas";
    }

    // Mapa para contar as ocorrências (ex: "Corrida": 2, "Bicicleta": 1)
    Map<String, int> contagem = {};

    for (var atividade in pessoa.atividades) {
      // Se não existir no mapa, o valor começa em 0 e soma 1.
      contagem[atividade.tipo] = (contagem[atividade.tipo] ?? 0) + 1;
    }

    // Pega na primeira chave só para ter um ponto de partida
    String maisFrequente = contagem.keys.first;

    // Itera pelo mapa para encontrar a chave (nome da atividade) com maior valor (quantidade)
    contagem.forEach((tipo, quantidade) {
      if (quantidade > contagem[maisFrequente]!) {
        maisFrequente = tipo;
      }
    });

    return "🏃 Atividade mais frequente: $maisFrequente";
  }

  // 🔹 Cruza os dados do IMC com as atividades para gerar um insight
  String impactoNoImc(PessoaModel pessoa) {
    // Se o utilizador não tiver pelo menos 2 registos de peso E atividades, não podemos comparar
    if (pessoa.registros.length < 2 || pessoa.atividades.isEmpty) {
      return "Dados insuficientes para análise de impacto";
    }

    double primeiro = pessoa.registros.first.imc;
    double ultimo = pessoa.registros.last.imc;

    if (ultimo < primeiro) {
      return "📉 As suas atividades estão a ajudar a reduzir o IMC!";
    } else if (ultimo > primeiro) {
      return "⚠️ Mesmo com atividades, o IMC aumentou (Verifique a dieta)";
    } else {
      return "➡️ O peso estabilizou, continue com as atividades!";
    }
  }
}
