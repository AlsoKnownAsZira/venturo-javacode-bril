import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/features/list/controllers/list_controller.dart';

class EditMenu extends StatelessWidget {
  final Map<String, dynamic> item;
  final ValueChanged<int> onQuantityChanged;

  EditMenu({
    Key? key,
    required this.item,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
        final ListController listController = Get.find(); // Use the same controller

    final menu = item['menu'];
    final quantity = RxInt(item['quantity']);
    final level = item['level'];
    final topping = item['topping'];
    final noteController = TextEditingController(text: item['note']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Menu'),
        backgroundColor: MainColor.primary,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: 'Catatan',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.h),
            if (level != null)
              TextField(
                decoration: InputDecoration(
                  labelText: 'Level',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  item['level'] = value;
                },
              ),
            SizedBox(height: 20.h),
            if (topping != null)
              TextField(
                decoration: InputDecoration(
                  labelText: 'Topping',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  item['topping'] = value;
                },
              ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (quantity.value > 1) {
                      quantity.value--;
                      onQuantityChanged(quantity.value);
                    }
                  },
                  icon: Icon(Icons.remove, color: MainColor.primary),
                ),
                Obx(() => Text(
                      "${quantity.value}",
                      style: TextStyle(fontSize: 20.w),
                    )),
                IconButton(
                  onPressed: () {
                    quantity.value++;
                    onQuantityChanged(quantity.value);
                  },
                  icon: Icon(Icons.add, color: MainColor.primary),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                item['note'] = noteController.text;
                Get.back();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}