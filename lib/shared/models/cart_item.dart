import 'package:hive/hive.dart';
import 'package:venturo_core/shared/models/menu.dart';
part 'cart_item.g.dart'; // This file will be generated by Hive

@HiveType(typeId: 2) // Unique type ID for Hive
class CartItem extends HiveObject {
  @HiveField(0)
  Item menu;

  @HiveField(1)
  int quantity;

  @HiveField(2)
  String? level;

  @HiveField(3)
  String? topping;

  @HiveField(4) 
  String? note; 

  CartItem({
    required this.menu,
    required this.quantity,
    this.level,
    this.topping,
    this.note,
  });
}
