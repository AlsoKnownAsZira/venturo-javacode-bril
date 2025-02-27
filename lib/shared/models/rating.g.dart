// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RatingModelAdapter extends TypeAdapter<RatingModel> {
  @override
  final int typeId = 3;

  @override
  RatingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RatingModel(
      category: fields[0] as String,
      rating: fields[1] as double,
      description: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RatingModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.rating)
      ..writeByte(2)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RatingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
