// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemAdapter extends TypeAdapter<Item> {
  @override
  final int typeId = 0;

  @override
  Item read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Item(
      idMenu: fields[0] as int,
      nama: fields[1] as String,
      kategori: fields[2] as Kategori,
      harga: fields[3] as int,
      deskripsi: fields[4] as String,
      foto: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.idMenu)
      ..writeByte(1)
      ..write(obj.nama)
      ..writeByte(2)
      ..write(obj.kategori)
      ..writeByte(3)
      ..write(obj.harga)
      ..writeByte(4)
      ..write(obj.deskripsi)
      ..writeByte(5)
      ..write(obj.foto);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class KategoriAdapter extends TypeAdapter<Kategori> {
  @override
  final int typeId = 1;

  @override
  Kategori read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Kategori.MAKANAN;
      case 1:
        return Kategori.MINUMAN;
      case 2:
        return Kategori.SNACK;
      default:
        return Kategori.MAKANAN;
    }
  }

  @override
  void write(BinaryWriter writer, Kategori obj) {
    switch (obj) {
      case Kategori.MAKANAN:
        writer.writeByte(0);
        break;
      case Kategori.MINUMAN:
        writer.writeByte(1);
        break;
      case Kategori.SNACK:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KategoriAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
