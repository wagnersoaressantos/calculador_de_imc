import 'package:calculadora_imc/model/imc_model.dart';

class CalculadorDeImc {
  static String calculadorDeImc(double peso, double altura) {
    // 1. Calculamos o IMC normalmente
    double imc = calcular(peso, altura);
    String imcFormatado = imc.toStringAsFixed(2);
    String classificacao = classificacaoIMC(imc);

    // --- FASE 3: INTELIGÊNCIA E ESTATÍSTICAS ---

    // 2. Descobrimos a faixa de peso ideal para esta altura exata
    double pesoMinimoIdeal = 18.5 * (altura * altura);
    double pesoMaximoIdeal = 24.9 * (altura * altura);

    // 3. Começamos a montar o nosso "Relatório Inteligente"
    String relatorioInteligente =
        'Seu IMC é: $imcFormatado\nClassificação: $classificacao\n\n';
    relatorioInteligente +=
        '🎯 Peso ideal: ${pesoMinimoIdeal.toStringAsFixed(1)}kg a ${pesoMaximoIdeal.toStringAsFixed(1)}kg.\n';

    // 4. Analisamos a diferença e damos a sugestão personalizada
    if (imc < 18.5) {
      double faltaGanhar = pesoMinimoIdeal - peso;
      relatorioInteligente +=
          '💡 Sugestão: Foco na hipertrofia! Você precisa ganhar cerca de ${faltaGanhar.toStringAsFixed(1)}kg para atingir a meta.';
    } else if (imc >= 25) {
      double faltaPerder = peso - pesoMaximoIdeal;
      relatorioInteligente +=
          '💡 Sugestão: Foco no déficit calórico! Recomendamos perder cerca de ${faltaPerder.toStringAsFixed(1)}kg para atingir a meta.';
    } else {
      relatorioInteligente +=
          '🎉 Parabéns! Você já está dentro da faixa de peso saudável. O foco agora é manter!';
    }

    // Retorna o texto completo que vai aparecer no "container branco" da sua tela
    return relatorioInteligente;
  }

  // Colocamos "static" para não precisarmos instanciar a classe toda vez
  static double calcular(double peso, double altura) {
    return peso / (altura * altura);
  }

  // Colocamos "static" aqui também
  static String classificacaoIMC(double imc) {
    // MELHORIA UX: Fornecer explicações e recomendações em vez de apenas a classificação crua
    if (imc < 16) {
      return "Magreza grave\n\nO seu peso está significativamente abaixo do ideal. Recomendamos procurar orientação médica para avaliação nutricional.";
    } else if (imc >= 16 && imc < 17) {
      return "Magreza moderada\n\nO seu peso está abaixo do normal. Uma dieta balanceada pode ajudar a alcançar um peso mais saudável.";
    } else if (imc >= 17 && imc < 18.5) {
      return "Magreza leve\n\nEstá quase no peso ideal. Continue a alimentar-se bem e a praticar exercício.";
    } else if (imc >= 18.5 && imc < 25) {
      return "Saudável (Peso normal)\n\nExcelente! O seu peso é considerado saudável. Mantenha os seus bons hábitos.";
    } else if (imc >= 25 && imc < 30) {
      return "Sobrepeso\n\nEstá um pouco acima do peso. Exercício regular e atenção à dieta podem ajudar a prevenir problemas de saúde.";
    } else if (imc >= 30 && imc < 35) {
      return "Obesidade Grau I\n\nAtenção. Este nível de IMC pode aumentar o risco de doenças cardiovasculares. Considere consultar um especialista.";
    } else if (imc >= 35 && imc < 40) {
      return "Obesidade Grau II (severa)\n\nRisco elevado para a saúde. É aconselhável procurar acompanhamento médico e nutricional para um plano adequado.";
    } else {
      return "Obesidade Grau III (mórbida)\n\nRisco muito elevado. Por favor, procure orientação médica o quanto antes para cuidar da sua saúde.";
    }
  }
}
