// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_result_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScanResultModelAdapter extends TypeAdapter<ScanResultModel> {
  @override
  final int typeId = 0;

  @override
  ScanResultModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScanResultModel(
      text: fields[0] as String,
      dateTime: fields[1] as DateTime,
      type: fields[2] as String?,
      status: fields[3] as String?,
      progress: fields[4] as double?,
      fileName: fields[5] as String?,
      category: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ScanResultModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.dateTime)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.progress)
      ..writeByte(5)
      ..write(obj.fileName)
      ..writeByte(6)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanResultModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
