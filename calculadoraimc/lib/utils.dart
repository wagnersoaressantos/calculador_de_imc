import 'dart:convert';
import 'dart:io';

double lerConsoleDouble(String texto){
  var numero = double.tryParse(lerconsole(texto));
  if (numero == null) {
    print('Número informado incorreto alterando para 0.0');
    return 0.0;
  } else {
    return numero;
  }
}

String lerconsole(String texto) {
  print(texto);
  var line = stdin.readLineSync(encoding: utf8);
  return line ?? "";
}