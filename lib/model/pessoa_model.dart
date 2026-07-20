import 'package:calculadora_imc/model/registro_imc_model.dart';
import 'package:calculadora_imc/model/atividade_model.dart'; // 🔥 Importação necessária!
import 'package:hive/hive.dart';

part 'pessoa_model.g.dart';

@HiveType(typeId: 0)
class PessoaModel extends HiveObject {
  @HiveField(0)
  String nome;

  @HiveField(1)
  List<RegistroImcModel> registros;

  @HiveField(2, defaultValue: 0.0)
  double alturaPadrao;

  @HiveField(3, defaultValue: 0.0)
  double pesoMeta;

  @HiveField(4, defaultValue: "Manter")
  String objetivo;

  // 🔥 NOVO: A lista de atividades associada exclusivamente a este perfil!
  @HiveField(5)
  List<AtividadeModel> atividades;

  // Construtor atualizado
  PessoaModel({
    required this.nome,
    required this.registros,
    this.alturaPadrao = 0.0,
    this.pesoMeta = 0.0,
    this.objetivo = "Manter",
    List<AtividadeModel>? atividades, // Opcional no momento da criação
  }) : atividades =
           atividades ??
           []; // Se for nulo, cria uma lista vazia para evitar erros
}
