class ConfiguracoesModel {
  String _nomeUsuario = "";
  double _alturaUsuario = 0;

  ConfiguracoesModel.vazio() {
    _nomeUsuario = "";
    _alturaUsuario = 0;
  }

  ConfiguracoesModel(this._nomeUsuario, this._alturaUsuario);

  String get nomeUsuario => _nomeUsuario;
  set nomeUsuario(String nomeUsuario) {
    _nomeUsuario = nomeUsuario;
  }

  double get alturaUsuario => _alturaUsuario;
  set alturaUsuario(double alturaUsuario) {
    _alturaUsuario = alturaUsuario;
  }
}