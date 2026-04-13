import 'package:hive/hive.dart';

part 'registro_imc_model.g.dart';

@HiveType(typeId: 1)
class RegistroImcModel extends HiveObject {

  @HiveField(0)
  double peso;

  @HiveField(1)
  double altura;

  @HiveField(2)
  double imc;

  @HiveField(3)
  DateTime data;

  RegistroImcModel({
    required this.peso,
    required this.altura,
    required this.imc,
    required this.data,
  });
}

