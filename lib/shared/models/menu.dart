import 'package:hive/hive.dart';
part 'menu.g.dart'; // This file will be generated by Hive

class Menu extends HiveObject {
  int statusCode;
  List<Item> data;

  Menu({
    required this.statusCode,
    required this.data,
  });
}
@HiveType(typeId: 0) // Unique type ID for Hive
class Item extends HiveObject {
  @HiveField(0)
  int idMenu;

  @HiveField(1)
  String nama;

  @HiveField(2)
  Kategori kategori;

  @HiveField(3)
  int harga;

  @HiveField(4)
  String deskripsi;

  @HiveField(5)
  String? foto;

  Item({
    required this.idMenu,
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.deskripsi,
    this.foto,
  });

  // Override equality operator and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Item && other.idMenu == idMenu;
  }

  @override
  int get hashCode => idMenu.hashCode;

  // Convert Item to Map (for debugging, not needed for Hive)
  Map<String, dynamic> toMap() {
    return {
      'id_menu': idMenu,
      'nama': nama,
      'kategori': kategori.name,
      'harga': harga,
      'deskripsi': deskripsi,
      'foto': foto,
    };
  }

  // Create Item from Map (for debugging, not needed for Hive)
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      idMenu: map['id_menu'] ?? 0,
      nama: map['nama'] ?? '',
      kategori: Kategori.values.firstWhere(
        (e) => e.name.toLowerCase() == map['kategori'].toString().toLowerCase(),
        orElse: () => Kategori.MAKANAN,
      ),
      harga: map['harga'] ?? 0,
      deskripsi: map['deskripsi'] ?? '',
      foto: map['foto'],
    );
  }
}

@HiveType(typeId: 1) // Unique type ID for Enum
enum Kategori {
  @HiveField(0)
  MAKANAN,

  @HiveField(1)
  MINUMAN,

  @HiveField(2)
  SNACK,
}