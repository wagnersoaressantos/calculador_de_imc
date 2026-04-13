import 'package:hive/hive.dart';
import 'registro_imc_model.dart';
import 'atividade_model.dart';

part 'pessoa_model.g.dart';

@HiveType(typeId: 3)
class PessoaModel extends HiveObject {

  @HiveField(0)
  String nome;

  @HiveField(1)
  double altura;

  @HiveField(2)
  List<RegistroImcModel> registros;

  @HiveField(3)
  List<AtividadeModel> atividades;

  PessoaModel({
    required this.nome,
    required this.altura,
    required this.registros,
    required this.atividades,
  });
}
