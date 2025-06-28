// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guardar_imc_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GuardarImcModelAdapter extends TypeAdapter<GuardarImcModel> {
  @override
  final int typeId = 0;

  @override
  GuardarImcModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GuardarImcModel(
      fields[0] as String,
      (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, GuardarImcModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.imc);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuardarImcModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
