// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pessoa_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PessoaModelAdapter extends TypeAdapter<PessoaModel> {
  @override
  final int typeId = 3;

  @override
  PessoaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PessoaModel(
      nome: fields[0] as String,
      altura: fields[1] as double,
      registros: (fields[2] as List).cast<RegistroImcModel>(),
      atividades: (fields[3] as List).cast<AtividadeModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, PessoaModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.altura)
      ..writeByte(2)
      ..write(obj.registros)
      ..writeByte(3)
      ..write(obj.atividades);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PessoaModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
