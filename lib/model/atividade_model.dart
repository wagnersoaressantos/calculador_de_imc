import 'package:hive/hive.dart';

part 'atividade_model.g.dart';

@HiveType(typeId: 2)
class AtividadeModel extends HiveObject {

  @HiveField(0)
  String tipo;

  @HiveField(1)
  int duracao;

  @HiveField(2)
  String intensidade;

  @HiveField(3)
  DateTime data;

  AtividadeModel({
    required this.tipo,
    required this.duracao,
    required this.intensidade,
    required this.data,
  });
}

