import 'package:calculadora_imc/model/guardar_imc_model.dart';
import 'package:hive/hive.dart';

class ImcRepository {
  
  late Box<GuardarImcModel> _box;

  ImcRepository(){
    _box = Hive.box<GuardarImcModel>('imcs');
  }

  void addImc(String nome, String valorImc) {
    final index = _box.values.toList().indexWhere((element) => element.nome == nome);
    if (index == -1) {
      final novo = GuardarImcModel(nome, [valorImc]);
      _box.add(novo);
    } else {
      final item = _box.keyAt(index);
      final model = _box.get(item);
      if(model != null){
      item.imc.add(valorImc);
      item.save();
      }
    }
  }

  List<GuardarImcModel> getImcList() {
    return _box.values.toList();
  }
}
