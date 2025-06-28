
import 'package:hive/hive.dart';

part 'guardar_imc_model.g.dart';

@HiveType(typeId: 0)
class GuardarImcModel {

  @HiveField(0)
  String nome;
  @HiveField(1)
  List<String> imc = [];

  GuardarImcModel(this.nome, this.imc);
}