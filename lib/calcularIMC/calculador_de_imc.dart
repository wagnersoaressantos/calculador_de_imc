import 'package:calculadora_imc/model/imc_model.dart';

class CalculadorDeImc {
  static String calculadorDeImc(double peso, double altura) {
    ImcModel pessoa = ImcModel(peso, altura);
    double pesoPessoa = pessoa.peso;
    double alturaPessoa = pessoa.altura;

    double imc = CalculadorDeImc().calcular(pesoPessoa, alturaPessoa);
    String imcFormatado = imc.toStringAsFixed(2);
    String classificacao = CalculadorDeImc().classificacaoIMC(imc);
    return 'Seu IMC é : $imcFormatado, \nClassificação: $classificacao ';
  }

  double calcular(double peso, double altura) {
    return peso / (altura * altura);
  }

  String classificacaoIMC(double imc) {
    if (imc < 16) return "Magreza grave";
    if (imc < 17) return "Magreza moderada";
    if (imc < 18.5) return "Magreza leve";
    if (imc < 25) return "Saudável";
    if (imc < 30) return "Sobrepeso";
    if (imc < 35) return "Obesidade Grau I";
    if (imc < 40) return "Obesidade Grau II (severa)";
    return "Obesidade Grau III (mórbida)";
  }
}
