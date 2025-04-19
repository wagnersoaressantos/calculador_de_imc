import 'package:calculadora_imc/model/guardar_imc_model.dart';

class ImcRepository {
  
  static final List<GuardarImcModel> _imcList = [];

  void addImc(String nome, String imc) {
    final index = _imcList.indexWhere((element) => element.nome == nome);
    if (index == -1) {
      _imcList.add(GuardarImcModel(nome, [imc]));
    } else {
      _imcList[index].imc.add(imc);
    }
  }

  List<GuardarImcModel> getImcList() {
    return _imcList;
  }
}
