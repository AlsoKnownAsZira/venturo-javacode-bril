import 'package:flutter/material.dart';
import 'package:venturo_core/configs/routes/route.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/features/list/controllers/list_controller.dart';
import 'package:venturo_core/features/list/sub_features/promo/controllers/list_promo_controller.dart';
import 'package:venturo_core/features/list/view/components/menu_card.dart';
import 'package:venturo_core/features/list/view/components/menu_chip.dart';
import 'package:venturo_core/features/list/view/components/promo_card.dart';
import 'package:venturo_core/features/list/view/components/search_app_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:venturo_core/shared/models/cart_item.dart';
import 'package:venturo_core/shared/widgets/custom_navbar.dart';

class ListScreen extends StatelessWidget {
  ListScreen({Key? key}) : super(key: key);
  final ListController listController = Get.find();
  final ListPromoController promoController = Get.put(ListPromoController());
  final RefreshController refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: MainColor.primary,
          onPressed: () {
            final cartBox = Hive.box<CartItem>('cartBox');
            if (cartBox.isEmpty) {
              Get.snackbar(
                'Peringatan',
                'Keranjang belanja kosong',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            } else {
              Get.toNamed(MainRoute.listCheckout);
            }
          },
          child: const Icon(
            Icons.shopping_cart,
            color: MainColor.white,
          ),
        ),
        bottomNavigationBar: const CustomNavbar(currentIndex: 0),
        appBar: SearchAppBar(
          onChange: (value) => ListController.to.keyword(value),
        ),
        body: SmartRefresher(
          controller: refreshController,
          enablePullDown: true,
          onRefresh: () async {
            listController.onRefresh();
            refreshController.refreshCompleted();
          },
          enablePullUp: listController.canLoadMore.isTrue,
          onLoading: () async {
            await listController.fetchData();
            refreshController.loadComplete();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Promo Section
                Padding(
                  padding: EdgeInsets.only(top: 20.h, left: 20.h),
                  child: Row(
                    children: [
                      Icon(Icons.local_offer,
                          size: 30.sp, color: MainColor.primary),
                      SizedBox(width: 10.w),
                      Text(
                        "Available Promo",
                        style: TextStyle(
                            fontSize: 25.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Obx(() {
                  if (promoController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return CarouselSlider(
                      options: CarouselOptions(
                        height: 200.h,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                      ),
                      items: promoController.promoList.map((promo) {
                        return Builder(
                          builder: (BuildContext context) {
                            return PromoCard(
                              promoName: promo["nama"] ?? '',
                              discountNominal: promo["diskon"] as int?,
                              nominal: promo["nominal"] as int?,
                              thumbnailUrl: promo["foto"] ?? '',
                              syaratKetentuan: promo["syarat_ketentuan"] ?? '',
                            );
                          },
                        );
                      }).toList(),
                    );
                  }
                }),

                SizedBox(height: 20.h),

                // Category Chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Obx(() => SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: listController.categories.map((category) {
                            return Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: MenuChip(
                                text: category,
                                icon: category == 'makanan'
                                    ? Icons.fastfood
                                    : category == 'minuman'
                                        ? Icons.emoji_food_beverage
                                        : category == 'snack'
                                            ? Icons.icecream
                                            : Icons.menu_book,
                                isSelected:
                                    listController.selectedCategory.value ==
                                        category.toLowerCase(),
                                onTap: () {
                                  listController.selectedCategory.value =
                                      category.toLowerCase();
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      )),
                ),

                SizedBox(height: 10.h),
                Obx(() {
                  final groupedItems = listController.groupedMenu;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: groupedItems.entries.map((entry) {
                      final category = entry.key;
                      final menus = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Kategori
                          Padding(
                            padding: EdgeInsets.only(top: 20.h, left: 20.h),
                            child: Row(
                              children: [
                                Icon(
                                  category == 'makanan'
                                      ? Icons.fastfood
                                      : category == 'minuman'
                                          ? Icons.emoji_food_beverage
                                          : Icons.icecream,
                                  size: 30.sp,
                                  color: MainColor.primary,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  category.capitalize!,
                                  style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),

                          // Daftar Menu dalam Kategori
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: menus.length,
                            itemBuilder: (context, index) {
                              final menu = menus[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: Slidable(
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          // ListController.to.deleteItem(menu);
                                        },
                                        borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(10.r),
                                        ),
                                        backgroundColor:
                                            const Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: MenuCard(
                                    menu: menu,
                                    isSelected: ListController.to.selectedItems
                                        .contains(menu),
                                    onTap: () {
                                      try {
                                        Get.toNamed(
                                          MainRoute.listDetail,
                                          arguments: menu,
                                        );
                                      } catch (e) {
                                        print("Navigation error: $e");
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }).toList(),
                  );
                }),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}