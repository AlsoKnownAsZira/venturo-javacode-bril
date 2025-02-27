import 'package:hive/hive.dart';

part 'rating.g.dart'; 

@HiveType(typeId: 1)
class RatingModel {
  @HiveField(0)
  final String category;

  @HiveField(1)
  final double rating;

  @HiveField(2)
  final String description;

  RatingModel({required this.category, required this.rating, required this.description});
}
