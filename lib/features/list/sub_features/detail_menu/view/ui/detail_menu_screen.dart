import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/features/list/controllers/list_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venturo_core/features/list/sub_features/checkout/view/ui/checkout_screen.dart';

class DetailMenuScreen extends StatelessWidget {
  DetailMenuScreen({Key? key}) : super(key: key);

  final ListController listController = Get.find(); // Use the same controller

  @override
  Widget build(BuildContext context) {
    final menu = Get.arguments;

    // Fetch menu details when the screen is opened
    listController.fetchMenuDetails(menu['id_menu']);

    void _showLevelBottomSheet() {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Obx(() => Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Select Level',
                      style: TextStyle(
                          fontSize: 20.w, fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    if (listController.levels.isEmpty)
                      Text(
                        'Tidak ada pilihan Level',
                        style: TextStyle(fontSize: 16.w),
                      )
                    else
                      Wrap(
                        spacing: 8.0,
                        children: listController.levels.map((level) {
                          return Obx(() => ChoiceChip(
                                label: Text(level),
                                selected:
                                    listController.selectedLevel.value == level,
                                onSelected: (selected) {
                                  if (selected) {
                                    listController.selectLevel(level);
                                  }
                                },
                              ));
                        }).toList(),
                      ),
                  ],
                ),
              ));
        },
      );
    }

    void _showToppingBottomSheet() {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Obx(() => Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Select Topping',
                      style: TextStyle(
                          fontSize: 20.w, fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    if (listController.toppings.isEmpty)
                      Text(
                        'Tidak ada pilhan Topping',
                        style: TextStyle(fontSize: 16.w),
                      )
                    else
                      Wrap(
                        spacing: 8.0,
                        children: listController.toppings.map((topping) {
                          return Obx(() => ChoiceChip(
                                label: Text(topping),
                                selected:
                                    listController.selectedTopping.value ==
                                        topping,
                                onSelected: (selected) {
                                  if (selected) {
                                    listController.selectTopping(topping);
                                  }
                                },
                              ));
                        }).toList(),
                      ),
                  ],
                ),
              ));
        },
      );
    }

    void _showCatatanBottomSheet() {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Add Catatan',
                      style: TextStyle(
                          fontSize: 20.w, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Masukkan catatan',
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.done,
                          color: MainColor.primary,
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          "Detail Menu",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: CachedNetworkImage(
                height: Get.height * 0.3,
                alignment: Alignment.center,
                imageUrl: menu['foto'] != null && menu['foto'].isNotEmpty
                    ? menu['foto']
                    : 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/240px-No_image_available.svg.png',
                useOldImageOnUrlChange: true,
                fit: BoxFit.contain,
                errorWidget: (context, url, error) => Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/240px-No_image_available.svg.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: Get.width,
              height: Get.height,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 0, 0, 0),
                    offset: Offset(0, 0),
                    blurRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            menu['nama'],
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: MainColor.primary),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 7.w),
                          Container(
                            width: 30.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: MainColor.primary),
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Center(
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () {
                                  ListController.to.decrement();
                                },
                                icon: const Icon(Icons.remove,
                                    color: MainColor.primary),
                              ),
                            ),
                          ),
                          SizedBox(width: 7.w),
                          Obx(() => Text(
                                '${ListController.to.quantity.value}',
                                style: TextStyle(fontSize: 20.w),
                              )),
                          SizedBox(width: 7.w),
                          Container(
                            width: 30.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              color: MainColor.primary,
                              border: Border.all(color: MainColor.primary),
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () {
                                ListController.to.increment();
                              },
                              icon: Icon(Icons.add, color: Colors.white),
                              
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                   SizedBox(
                    height: 20.w,
                  ),
                  Flexible(
                    child: Text(
                      menu['deskripsi'],
                      style: const TextStyle(
                          fontSize: 16, overflow: TextOverflow.ellipsis),
                      maxLines: 3, // Limit the number of lines
                    ),
                  ),
                  SizedBox(
                    height: 70.w,
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: MainColor.primary,
                        size: 20.w,
                      ),
                      Text(
                        'Harga',
                        style: TextStyle(
                            fontSize: 20.w, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        "Rp ${menu['harga']}",
                        style: TextStyle(
                            fontSize: 20.w,
                            fontWeight: FontWeight.bold,
                            color: MainColor.primary),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        color: MainColor.primary,
                        size: 20.w,
                      ),
                      Text(
                        'Level',
                        style: TextStyle(
                            fontSize: 20.w, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            _showLevelBottomSheet();
                          },
                          icon: const Icon(Icons.arrow_forward_ios),
                          style: ButtonStyle(
                              iconSize: MaterialStateProperty.all(20.w))),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Icon(
                        Icons.extension_sharp,
                        color: MainColor.primary,
                        size: 20.w,
                      ),
                      Text(
                        'Topping',
                        style: TextStyle(
                            fontSize: 20.w, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            _showToppingBottomSheet();
                          },
                          icon: const Icon(Icons.arrow_forward_ios),
                          style: ButtonStyle(
                              iconSize: MaterialStateProperty.all(20.w))),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Icon(
                        Icons.edit_note,
                        color: MainColor.primary,
                        size: 20.w,
                      ),
                      Text(
                        'Catatan',
                        style: TextStyle(
                            fontSize: 20.w, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            _showCatatanBottomSheet();
                          },
                          icon: const Icon(Icons.arrow_forward_ios),
                          style: ButtonStyle(
                              iconSize: MaterialStateProperty.all(20.w))),
                    ],
                  ),
                  SizedBox(
                    height: 25.w,
                  ),
                  SizedBox(
                    width: Get.width,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MainColor.primary,
                        ),
                       onPressed: () {
                          Get.to(() => CheckoutScreen(), arguments: {
                            'menu': menu,
                            'quantity': listController.quantity.value,
                          });
                        },
                        child: Text(
                          'Tambah ke Pesanan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20.w),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
