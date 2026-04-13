// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registro_imc_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RegistroImcModelAdapter extends TypeAdapter<RegistroImcModel> {
  @override
  final int typeId = 1;

  @override
  RegistroImcModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RegistroImcModel(
      peso: fields[0] as double,
      altura: fields[1] as double,
      imc: fields[2] as double,
      data: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RegistroImcModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.peso)
      ..writeByte(1)
      ..write(obj.altura)
      ..writeByte(2)
      ..write(obj.imc)
      ..writeByte(3)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegistroImcModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
