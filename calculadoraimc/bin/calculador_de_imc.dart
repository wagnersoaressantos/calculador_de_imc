import 'package:calculador_de_imc/calcularIMC/calculador_de_imc.dart';
import 'package:calculador_de_imc/pessoa/pessoa.dart';
import 'package:calculador_de_imc/utils.dart' as utils;

void main(List<String> arguments) {
  print('Bem vindo a nossa calculadora de IMC!');
  var nome = utils.lerconsole('Informe seu nome:');
  var peso = utils.lerConsoleDouble('Informe seu peso (ex 55.0):');
  var altura = utils.lerConsoleDouble('Informe sua Altura em metros (ex 1.69):');

  var pessoa = Pessoa(peso, altura, nome: nome);
  String nomePessoa = pessoa.nome;
  double pesoPessoa = pessoa.peso;
  double alturaPessoa = pessoa.altura;

  double imc = CalculadorDeImc().calcular(pesoPessoa,alturaPessoa);
  String imcFormatado = imc.toStringAsFixed(2);
  String classificacao = CalculadorDeImc().classificacaoIMC(imc);

  print('${'_'*20}\nConforme os dados:\nnome:$nomePessoa\npeso:$pesoPessoa\naltura:$alturaPessoa\n${'_'*20}\nEste é seu IMC e Classificação: $imcFormatado -> $classificacao');

}