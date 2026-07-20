// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pessoa_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PessoaModelAdapter extends TypeAdapter<PessoaModel> {
  @override
  final int typeId = 0;

  @override
  PessoaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PessoaModel(
      nome: fields[0] as String,
      registros: (fields[1] as List).cast<RegistroImcModel>(),
      alturaPadrao: fields[2] == null ? 0.0 : fields[2] as double,
      pesoMeta: fields[3] == null ? 0.0 : fields[3] as double,
      objetivo: fields[4] == null ? 'Manter' : fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PessoaModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.registros)
      ..writeByte(2)
      ..write(obj.alturaPadrao)
      ..writeByte(3)
      ..write(obj.pesoMeta)
      ..writeByte(4)
      ..write(obj.objetivo);
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
