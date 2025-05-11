// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ViewingHistory.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ViewingHistoryAdapter extends TypeAdapter<ViewingHistory> {
  @override
  final int typeId = 1;

  @override
  ViewingHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ViewingHistory(
      userId: fields[0] as int,
      videoId: fields[1] as int,
      progress: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ViewingHistory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.videoId)
      ..writeByte(2)
      ..write(obj.progress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ViewingHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
