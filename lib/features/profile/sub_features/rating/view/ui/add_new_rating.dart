import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/features/profile/sub_features/rating/controllers/rating_controller.dart';
import 'package:venturo_core/shared/models/rating.dart';

class AddNewRating extends StatelessWidget {
  final RatingController ratingController = Get.put(RatingController());

  final Map<int, String> ratingTexts = {
    1: 'Sangat Buruk',
    2: 'Buruk',
    3: 'Cukup',
    4: 'Baik',
    5: 'Sempurna'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penilaian'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Berikan Penilaianmu',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Obx(() => RatingBar.builder(
                                  initialRating: ratingController.rating.value,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    ratingController.updateRating(rating);
                                  },
                                )),
                            const Spacer(),
                            Obx(() => Text(
                                  ratingTexts[ratingController.rating.value
                                          .round()] ??
                                      '',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Apa yang perlu ditingkatkan?',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Obx(() => Wrap(
                              spacing: 8.0,
                              children:
                                  ratingController.categories.map((category) {
                                return ChoiceChip(
                                  disabledColor: MainColor.grey,
                                  backgroundColor: Colors.grey[200],
                                  selectedColor: MainColor.white,
                                  side: const BorderSide(
                                      color: MainColor.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  label: Text(
                                    category,
                                    style: const TextStyle(
                                        color: MainColor.primary),
                                  ),
                                  selected:
                                      ratingController.selectedCategory.value ==
                                          category,
                                  onSelected: (selected) {
                                    ratingController.updateCategory(category);
                                  },
                                );
                              }).toList(),
                            )),
                        const SizedBox(height: 16),
                        const Divider(),
                        const Text(
                          'Tulis Review',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          onChanged: (value) {
                            ratingController.updateDescription(value);
                          },
                          maxLines: 4,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            hintText: 'Tulis Review Anda',
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MainColor.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60),
                              ),
                            ),
                            onPressed: () {
                              final newRating = RatingModel(
                                category:
                                    ratingController.selectedCategory.value,
                                rating: ratingController.rating.value,
                                description: ratingController.description.value,
                              );

                              Get.back(
                                  result:
                                      newRating); // Return the new rating to the previous screen
                            },
                            child: const Text(
                              'Kirim Penilaian',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
