class ConfiguracoesModel {
  String _nomeUsuario = "";
  double _alturaUsuario = 0;
  double _pesoMeta = 0; // Novo campo
  String _objetivo = "Manter"; // Novo campo (Emagrecer, Hipertrofia, Manter)

  ConfiguracoesModel.vazio() {
    _nomeUsuario = "";
    _alturaUsuario = 0;
    _pesoMeta = 0;
    _objetivo = "Manter";
  }

  ConfiguracoesModel(
    this._nomeUsuario,
    this._alturaUsuario,
    this._pesoMeta,
    this._objetivo,
  );

  String get nomeUsuario => _nomeUsuario;
  set nomeUsuario(String value) => _nomeUsuario = value;

  double get alturaUsuario => _alturaUsuario;
  set alturaUsuario(double value) => _alturaUsuario = value;

  double get pesoMeta => _pesoMeta;
  set pesoMeta(double value) => _pesoMeta = value;

  String get objetivo => _objetivo;
  set objetivo(String value) => _objetivo = value;
}
