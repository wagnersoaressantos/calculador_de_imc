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
    });
  }

  ConfiguracoesModel pegarDados() {
    var configuracao = _box.get('configuracoesModel');
    if (configuracao == null) {
      return ConfiguracoesModel.vazio();
    } else {
      return ConfiguracoesModel(
        configuracao['nomeUsuario'],
        configuracao['alturaUsuario'],
      );
    }
  }
}
