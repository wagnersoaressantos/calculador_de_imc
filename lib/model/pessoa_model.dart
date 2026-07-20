import 'package:calculadora_imc/model/registro_imc_model.dart';
import 'package:hive/hive.dart';

part 'pessoa_model.g.dart';

@HiveType(typeId: 0)
class PessoaModel extends HiveObject {
  @HiveField(0)
  String nome;

  @HiveField(1)
  List<RegistroImcModel> registros;

  // 🔥 NOVOS CAMPOS ADICIONADOS PARA A FASE 3 (SISTEMA DE PERFIS)

  @HiveField(2, defaultValue: 0.0)
  double alturaPadrao;

  @HiveField(3, defaultValue: 0.0)
  double pesoMeta;

  @HiveField(4, defaultValue: "Manter")
  String objetivo;

  // Construtor atualizado
  PessoaModel({
    required this.nome,
    required this.registros,
    this.alturaPadrao = 0.0,
    this.pesoMeta = 0.0,
    this.objetivo = "Manter",
  });
}
