import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:venturo_core/features/profile/sub_features/rating/controllers/rating_controller.dart';
import 'package:venturo_core/shared/models/rating.dart';

class AddNewRating extends StatelessWidget {
  final RatingController ratingController = Get.put(RatingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penilaian'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const Text(
              'Berikan Penilaianmu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Obx(() => RatingBar.builder(
                  initialRating: ratingController.rating.value,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    ratingController.updateRating(rating);
                  },
                )),
            const SizedBox(height: 16),
            const Text(
              'Apa yang perlu ditingkatkan?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Obx(() => Wrap(
                  spacing: 8.0,
                  children: ratingController.categories.map((category) {
                    return ChoiceChip(
                      label: Text(category),
                      selected:
                          ratingController.selectedCategory.value == category,
                      onSelected: (selected) {
                        ratingController.updateCategory(category);
                      },
                    );
                  }).toList(),
                )),
            const SizedBox(height: 16),
           
            const Text(
              'Tulis Review',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              onChanged: (value) {
                ratingController.updateDescription(value);
              },
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Tulis Review Anda',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final newRating = RatingModel(
                  category: ratingController.selectedCategory.value,
                  rating: ratingController.rating.value,
                  description: ratingController.description.value,
                );

                Get.back(
                    result: newRating); // Pastikan mengembalikan RatingModel
              },
              child: const Text('Submit Rating'),
            ),
          ],
        ),
      ),
    );
  }
}
