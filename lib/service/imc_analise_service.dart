import 'package:calculadora_imc/model/registro_imc_model.dart';

class ImcAnaliseService {
  // 🔹 Calcula a média dos IMCs registados
  double calcularMedia(List<RegistroImcModel> registros) {
    if (registros.isEmpty) return 0.0;

    double soma = 0;
    for (var r in registros) {
      soma += r.imc;
    }

    // Retorna a média
    return soma / registros.length;
  }

  // 🔹 Verifica tendência (subindo ou descendo) comparando o primeiro com o último
  String calcularTendencia(List<RegistroImcModel> registros) {
    if (registros.length < 2) return "Sem dados suficientes";

    // Usamos o 'first' (mais antigo) e 'last' (mais recente)
    final primeiro = registros.first.imc;
    final ultimo = registros.last.imc;

    // Se o valor mais recente for menor que o primeiro, está a descer!
    if (ultimo < primeiro) {
      return "📉 Seu IMC está a diminuir";
    } else if (ultimo > primeiro) {
      return "📈 Seu IMC está a aumentar";
    } else {
      return "➡️ O seu IMC está estável";
    }
  }

  // 🔹 Previsão simples baseada na diferença entre o primeiro e o último registo
  String preverMeta(List<RegistroImcModel> registros) {
    if (registros.length < 2) {
      return "Dados insuficientes para previsão";
    }

    final primeiro = registros.first.imc;
    final ultimo = registros.last.imc;

    // O quanto a pessoa perdeu (ou ganhou) desde que começou
    final diferenca = primeiro - ultimo;

    // Se a diferença for negativa ou zero, não está a perder peso (não há como prever a meta se a meta for emagrecer)
    if (diferenca <= 0) {
      return "Sem progresso suficiente para uma previsão";
    }

    // Calcula a média de redução por registo
    double mediaReducao = diferenca / registros.length;

    // Formata o texto para mostrar a redução média por registo (ajudando o utilizador a ver pequenos progressos)
    return "🔮 Redução média de ${mediaReducao.toStringAsFixed(2)} pontos de IMC por registo";
  }
}
