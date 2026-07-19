import 'package:calculadora_imc/model/pessoa_model.dart';
import 'package:flutter/material.dart';

// Esta classe funciona como um "Mega-fone" (ChangeNotifier)
// Toda a vez que o utilizador ativo mudar, ela avisa as outras páginas para se atualizarem.
class SessaoUsuario extends ChangeNotifier {
  PessoaModel? _usuarioAtivo;

  PessoaModel? get usuarioAtivo => _usuarioAtivo;

  void selecionarUsuario(PessoaModel pessoa) {
    _usuarioAtivo = pessoa;
    // Avisa a HomePage, Dashboard, etc., que a pessoa mudou!
    notifyListeners();
  }

  void limparSessao() {
    _usuarioAtivo = null;
    notifyListeners();
  }
}
