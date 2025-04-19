import 'package:flutter_test/flutter_test.dart';
import 'package:calculadora_imc/calcularIMC/calculador_de_imc.dart';

void main() {
  test("Cálculo do IMC com valores normais", () {
    var imc = CalculadorDeImc().calcular(70, 1.75);
    String imcFormatado = imc.toStringAsFixed(2);
    var classificacao = CalculadorDeImc().classificacaoIMC(imc);
    expect(imcFormatado, '22.86');
    expect(classificacao, "Saudável");
  });
  test("IMC muito baixo", () {
    var imc = CalculadorDeImc().calcular(45, 1.75);
    var classificacao = CalculadorDeImc().classificacaoIMC(imc);
    expect(classificacao, "Magreza grave");
  });
  test("IMC indicando obesidade", () {
    var imc = CalculadorDeImc().calcular(100, 1.75);
    var classificacao = CalculadorDeImc().classificacaoIMC(imc);
    expect(classificacao, "Obesidade Grau I");
  });
}
