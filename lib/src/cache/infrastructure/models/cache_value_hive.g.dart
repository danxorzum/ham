// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_value_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CacheValueHiveAdapter extends TypeAdapter<CacheValueHive> {
  @override
  final int typeId = 0;

  @override
  CacheValueHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheValueHive(
      cacheKey: fields[0] as String,
      value: (fields[1] as Map).cast<String, dynamic>(),
      expirationDate: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CacheValueHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.cacheKey)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.expirationDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheValueHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
