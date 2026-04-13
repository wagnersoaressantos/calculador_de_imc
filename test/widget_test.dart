import 'package:calculadora_imc/model/atividade_model.dart';
import 'package:calculadora_imc/model/pessoa_model.dart';
import 'package:calculadora_imc/model/registro_imc_model.dart';
import 'package:calculadora_imc/repository/pessoa_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculadora_imc/calcularIMC/calculador_de_imc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  


void main() {

  setUpAll(() async {
    await Hive.initFlutter();

    Hive.registerAdapter(RegistroImcModelAdapter());
    Hive.registerAdapter(AtividadeModelAdapter());
    Hive.registerAdapter(PessoaModelAdapter());

    await Hive.openBox<PessoaModel>('pessoas');
  });

  test("teste repo", () {
    final repo = PessoaRepository();

    repo.adicionarRegistro(
      nome: "Wagner",
      peso: 80,
      altura: 1.75,
    );

    final lista = repo.listarPessoas();

    expect(lista.isNotEmpty, true);
    expect(lista.first.registros.length, 1);
  });
}}