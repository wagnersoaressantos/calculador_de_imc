import 'package:calculadora_imc/model/configuracao_model.dart';
import 'package:hive/hive.dart';

class ConfiguracoesRepository {
  static late Box _box;

  static Future<ConfiguracoesRepository> load() async {
    if (Hive.isBoxOpen('configuracoes')) {
      _box = Hive.box('configuracoes');
    } else {
      _box = await Hive.openBox('configuracoes');
    }

    return ConfiguracoesRepository._load();
  }

  ConfiguracoesRepository._load();

  void salvar(ConfiguracoesModel configuracoesModel) {
    _box.put("configuracoesModel", {
      "nomeUsuario": configuracoesModel.nomeUsuario,
      "alturaUsuario": configuracoesModel.alturaUsuario,
      "pesoMeta": configuracoesModel.pesoMeta, // Salvar
      "objetivo": configuracoesModel.objetivo, // Salvar
    });
  }

  ConfiguracoesModel pegarDados() {
    var configuracao = _box.get('configuracoesModel');
    if (configuracao == null) {
      return ConfiguracoesModel.vazio();
    } else {
      // Usamos '?? 0' para garantir que, se o campo não existir, ele assume 0 em vez de dar erro
      return ConfiguracoesModel(
        configuracao['nomeUsuario'] ?? "",
        (configuracao['alturaUsuario'] as num? ?? 0).toDouble(),
        (configuracao['pesoMeta'] as num? ?? 0)
            .toDouble(), // Se for null, vira 0
        configuracao['objetivo'] ?? "Manter", // Se for null, vira "Manter"
      );
    }
  }
}
