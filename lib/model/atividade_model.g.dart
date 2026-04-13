// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atividade_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AtividadeModelAdapter extends TypeAdapter<AtividadeModel> {
  @override
  final int typeId = 2;

  @override
  AtividadeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AtividadeModel(
      tipo: fields[0] as String,
      duracao: fields[1] as int,
      intensidade: fields[2] as String,
      data: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AtividadeModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.tipo)
      ..writeByte(1)
      ..write(obj.duracao)
      ..writeByte(2)
      ..write(obj.intensidade)
      ..writeByte(3)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AtividadeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
