import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/features/list/constants/list_assets_constant.dart';
import 'package:venturo_core/features/list/controllers/list_controller.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({Key? key}) : super(key: key);

  final assetsConstant = ListAssetsConstant();
  final ListController listController = Get.find(); // Use the same controller

  @override
  Widget build(BuildContext context) {
    final cartBox = Hive.box('cartBox');
    final items = cartBox.values.toList();

    // Grouping items by kategori
    Map<String, List<dynamic>> groupedItems = {};

    for (var item in items) {
      String kategori = item['kategori'] ?? 'Lainnya';
      if (!groupedItems.containsKey(kategori)) {
        groupedItems[kategori] = [];
      }
      groupedItems[kategori]!.add(item);
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
          "Pesanan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ...groupedItems.entries.map((entry) {
              String kategori = entry.key;
              List<dynamic> kategoriItems = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 16.w),
                    child: Text(
                      kategori,
                      style: TextStyle(
                          fontSize: 22.w, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...kategoriItems.map((item) {
                    final menu = item['menu'];
                    final quantity = item['quantity'];
                    final level = item['level'];
                    final topping = item['topping'];

                    return ListTile(
                      leading: CachedNetworkImage(
                        height: 90.h,
                        width: 90.w,
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
                      title: Text(menu['nama']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Rp ${menu['harga']}"),
                          if (level != null) Text("Level: $level"),
                          if (topping != null) Text("Topping: $topping"),
                        ],
                      ),
                      trailing: Text("Qty: $quantity"),
                    );
                  }).toList(),
                ],
              );
            }).toList(),
            SizedBox(height: 365.h),
            Container(
              width: Get.width,
              height: Get.height * 0.303,
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
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Pesanan (${items.length}) Item:",
                          style: TextStyle(
                              fontSize: 20.w, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Rp ${items.fold<int>(0, (sum, item) => sum + (item['quantity'] * item['menu']['harga'] as int))}",
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
                          Icons.discount,
                          color: MainColor.primary,
                          size: 20.w,
                        ),
                        Text(
                          'Diskon',
                          style: TextStyle(
                              fontSize: 20.w, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_forward_ios),
                            style: ButtonStyle(
                                iconSize: MaterialStateProperty.all(20.w))),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          color: MainColor.primary,
                          size: 20.w,
                        ),
                        Text(
                          'Voucher',
                          style: TextStyle(
                              fontSize: 20.w, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_forward_ios),
                            style: ButtonStyle(
                                iconSize: MaterialStateProperty.all(20.w))),
                      ],
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
                          'Pembayaran',
                          style: TextStyle(
                              fontSize: 20.w, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_forward_ios),
                            style: ButtonStyle(
                                iconSize: MaterialStateProperty.all(20.w))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
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
              width: Get.width,
              height: Get.height * 0.11,
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: MainColor.primary,
                      size: 20.w,
                    ),
                    Column(
                      children: [
                        Text(
                          'Total Pembayaran',
                          style: TextStyle(
                              fontSize: 20.w, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Rp ${items.fold<int>(0, (sum, item) => sum + (item['quantity'] * item['menu']['harga'] as int))}",
                          style: TextStyle(
                              fontSize: 20.w,
                              fontWeight: FontWeight.bold,
                              color: MainColor.primary),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MainColor.primary),
                        onPressed: () {
                          cartBox.clear();
                          Get.snackbar(
                              "Success", "Pesanan berhasil dibuat");
                        },
                        child: Text(
                          "Pesan Sekarang",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.w,
                              color: Colors.white),
                        ))
                  ],
                ),
              ),
            )
            // Add more widgets to display other details or actions
          ],
        ),
      ),
    );
  }
}