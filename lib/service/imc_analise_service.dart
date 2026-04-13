import 'package:calculadora_imc/model/registro_imc_model.dart';

class ImcAnaliseService {
  // 🔹 Calcula média dos IMCs
  double calcularMedia(List<RegistroImcModel> registros) {
    if (registros.isEmpty) return 0;

    double soma = 0;

    for (var r in registros) {
      soma += r.imc;
    }

    return soma / registros.length;
  }

  // 🔹 Verifica tendência (subindo ou descendo)
  String calcularTendencia(List<RegistroImcModel> registros) {
    if (registros.length < 2) return "Sem dados suficientes";

    final primeiro = registros.first.imc;
    final ultimo = registros.last.imc;

    if (ultimo < primeiro) {
      return "📉 Seu IMC está diminuindo";
    } else if (ultimo > primeiro) {
      return "📈 Seu IMC está aumentando";
    } else {
      return "➡️ IMC está estável";
    }
  }

  // 🔹 Previsão simples
  String preverMeta(List<RegistroImcModel> registros) {
    if (registros.length < 2) {
      return "Dados insuficientes para previsão";
    }

    final primeiro = registros.first.imc;
    final ultimo = registros.last.imc;

    final diferenca = primeiro - ultimo;

    if (diferenca <= 0) {
      return "Sem progresso suficiente para previsão";
    }

    // média de redução por registro
    double mediaReducao = diferenca / registros.length;

    // meta IMC ideal (25)
    double alvo = 25;

    double falta = ultimo - alvo;

    if (falta <= 0) {
      return "🎉 Você já está no IMC ideal!";
    }

    double passos = falta / mediaReducao;

    return "🔮 Estimativa: ${passos.toStringAsFixed(0)} registros para atingir IMC ideal";
  }
}
