import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:venturo_core/configs/routes/route.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/constants/image_constant.dart';
import 'package:venturo_core/features/list/constants/list_assets_constant.dart';
import 'package:venturo_core/features/list/controllers/list_controller.dart';
import 'package:venturo_core/features/list/sub_features/checkout/view/components/checkout_item_card.dart';
import 'package:venturo_core/shared/models/cart_item.dart';
import 'package:venturo_core/shared/models/menu.dart';

class CheckoutScreen extends StatefulWidget {
  CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final assetsConstant = ListAssetsConstant();
  final ListController listController = Get.find(); // Use the same controller

  String selectedVoucher = '';
  int selectedVoucherAmount = 0;
  String selectedPaymentMethod = '';

  @override
  Widget build(BuildContext context) {
    final cartBox = Hive.box<CartItem>('cartBox');
    // Retrieve items from Hive and convert them to CartItem list
    List<CartItem> items = cartBox.values.toList();

    // Grouping items by kategori and combining same menu orders
    Map<Kategori, List<CartItem>> groupedItems = {};

    for (var item in items) {
      Kategori kategori = item.menu.kategori;

      if (!groupedItems.containsKey(kategori)) {
        groupedItems[kategori] = [];
      }

      var existingItem = groupedItems[kategori]!.firstWhereOrNull(
          (element) => element.menu.idMenu == item.menu.idMenu);

      if (existingItem != null) {
        existingItem.quantity += item.quantity;
      } else {
        groupedItems[kategori]!.add(item);
      }
    }

    IconData getCategoryIcon(String kategori) {
      switch (kategori.toLowerCase()) {
        case 'makanan':
          return Icons.fastfood;
        case 'minuman':
          return Icons.local_drink;
        case 'snack':
          return Icons.local_pizza;
        default:
          return Icons.category;
      }
    }

    // Calculate the total quantity of items
    int totalQuantity = items.fold<int>(0, (sum, item) => sum + item.quantity);

    // Calculate the total price of items
    int totalPrice = items.fold<int>(
        0, (sum, item) => sum + (item.quantity * item.menu.harga));

    // Calculate the discount amount (20%)
    double discount = selectedVoucherAmount > 0 ? 0 : totalPrice * 0.20;

    // Calculate the total payment after discount and voucher
    double totalPayment = totalPrice - discount - selectedVoucherAmount;

    // Ensure total payment is not less than or equal to zero
    if (totalPayment <= 0) {
      totalPayment = 0;
    }

    void _showEditNoteDialog(CartItem item) {
      TextEditingController noteController =
          TextEditingController(text: item.note);

      Get.defaultDialog(
        title: 'Edit Note',
        content: Column(
          children: [
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                hintText: 'Enter note',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  item.note = noteController.text;
                  cartBox.put(item.key, item); // Update the item in the box
                });
                Get.back();
              },
              child: Text('Save'),
            ),
          ],
        ),
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
          "Pesanan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ...groupedItems.entries.map((entry) {
              Kategori kategori = entry.key;
              List<CartItem> kategoriItems = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.w, horizontal: 16.w),
                      child: Row(children: [
                        Icon(
                          getCategoryIcon(kategori.name),
                          size: 22.w,
                          color: MainColor.primary,
                        ),
                        Text(
                          kategori.name,
                          style: TextStyle(
                              fontSize: 22.w, fontWeight: FontWeight.bold),
                        ),
                      ])),
                  ...kategoriItems.map((item) {
                    return GestureDetector(
                      onTap: () {
                        _showEditNoteDialog(item);
                      },
                      child: CheckoutItemCard(
                        item: {
                          'menu': item.menu.toMap(),
                          'quantity': item.quantity,
                          'level': item.level,
                          'topping': item.topping,
                          'note': item.note, // Add this line
                        },
                      ),
                    );
                  }),
                ],
              );
            }),
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
                          "Total Pesanan ($totalQuantity) Item:",
                          style: TextStyle(
                              fontSize: 20.w, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Rp $totalPrice",
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
                          selectedVoucherAmount > 0
                              ? 'Diskon tidak bisa digunakan dengan voucher'
                              : 'Diskon 20%',
                          style: TextStyle(
                              fontSize: 16.w, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Text(
                              selectedVoucherAmount > 0
                                  ? ""
                                  : "- Rp ${discount.toInt()}",
                              style: TextStyle(
                                  fontSize: 20.w,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                            IconButton(
                                onPressed: () {
                                  Get.defaultDialog(
                                    title: 'Rincian Diskon',
                                    titleStyle: const TextStyle(
                                        color: MainColor.primary,
                                        fontWeight: FontWeight.bold),
                                    content: const Column(
                                      children: [
                                        ListTile(
                                          title: Text('Mengisi Survey'),
                                          trailing: Text(
                                            '10%',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text('Terlambat <3x'),
                                          trailing: Text(
                                            '10%',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                                icon: const Icon(Icons.arrow_forward_ios),
                                style: ButtonStyle(
                                    iconSize: MaterialStateProperty.all(20.w))),
                          ],
                        ),
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
                        Text(
                          "- Rp $selectedVoucherAmount",
                          style: TextStyle(
                              fontSize: 20.w,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        IconButton(
                            onPressed: () async {
                              final result =
                                  await Get.toNamed(MainRoute.checkoutVoucher);
                              if (result != null) {
                                setState(() {
                                  selectedVoucher = result['voucher'];
                                  selectedVoucherAmount = result['amount'];
                                });
                              }
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
                        Text(
                          selectedPaymentMethod.isEmpty
                              ? 'Pilih metode pembayaran'
                              : selectedPaymentMethod,
                          style: TextStyle(
                              fontSize: 20.w,
                              fontWeight: FontWeight.bold,
                              color: selectedPaymentMethod.isEmpty
                                  ? Colors.red
                                  : MainColor.primary),
                        ),
                        IconButton(
                            onPressed: () {
                              Get.bottomSheet(
                                backgroundColor: Colors.white,
                                Container(
                                  width: Get.width,
                                  padding: EdgeInsets.all(20.w),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Pilih Metode Pembayaran',
                                        style: TextStyle(
                                            fontSize: 20.w,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10.h),
                                      Wrap(
                                        spacing: 10.w,
                                        children: [
                                          ChoiceChip(
                                            label: const Text('Paylater'),
                                            selected: selectedPaymentMethod ==
                                                'Paylater',
                                            onSelected: (bool selected) {
                                              setState(() {
                                                selectedPaymentMethod =
                                                    selected ? 'Paylater' : '';
                                              });
                                            },
                                            selectedColor: MainColor.primary,
                                            backgroundColor: Colors.grey[200],
                                          ),
                                          ChoiceChip(
                                            label: const Text('Cash'),
                                            selected:
                                                selectedPaymentMethod == 'Cash',
                                            onSelected: (bool selected) {
                                              setState(() {
                                                selectedPaymentMethod =
                                                    selected ? 'Cash' : '';
                                              });
                                            },
                                            selectedColor: MainColor.primary,
                                            backgroundColor: Colors.grey[200],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20.h),
                                      ElevatedButton(
                                        onPressed: () => Get.back(),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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
              height:
                  Get.height * 0.11, // Set a fixed height for the bottom sheet
              child:
                  CheckoutSummary(totalPayment: totalPayment, cartBox: cartBox),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckoutSummary extends StatelessWidget {
  const CheckoutSummary({
    super.key,
    required this.totalPayment,
    required this.cartBox,
  });

  final double totalPayment;
  final Box<CartItem> cartBox;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  style: TextStyle(fontSize: 20.w, fontWeight: FontWeight.bold),
                ),
                Text(
                  totalPayment == 0
                      ? "Rp 0 (Free)"
                      : "Rp ${totalPayment.toInt()}",
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
                  Get.defaultDialog(
                    title: 'Rincian Diskon',
                    titleStyle: const TextStyle(
                        color: MainColor.primary, fontWeight: FontWeight.bold),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(ImageConstant.confirm),
                        const SizedBox(height: 10),
                        const Text('Pesanan Sedang Disiapkan',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        const Text(
                            'Kamu dapat melacak pesananmu di fitur Pesanan'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.offAndToNamed(MainRoute.list),
                        child: const Text('OK'),
                      ),
                    ],
                  );
                  cartBox.clear();
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
    );
  }
}
