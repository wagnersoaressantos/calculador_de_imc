class ImcModel {
  
  double _peso;
  double _altura;

  ImcModel(this._peso, this._altura);

  double get peso => _peso;
  set peso(double value) {
    _peso = value;
  }
  double get altura => _altura;
  set altura(double value) {
    _altura = value;
  }
  
}