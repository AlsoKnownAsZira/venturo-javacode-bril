import 'package:get/get.dart';

class RatingController extends GetxController {
  var rating = 0.0.obs;
  var selectedCategory = 'Service Quality'.obs;
  var description = ''.obs;

  final List<String> categories = [
    'Harga',
    'Rasa',
    'Penyajian Makanan',
    'Pelayanan',
    'Fasilitas'
  ];

  void updateRating(double newRating) {
    rating.value = newRating;
  }

  void updateCategory(String newCategory) {
    selectedCategory.value = newCategory;
  }

  void updateDescription(String newDescription) {
    description.value = newDescription;
  }
}