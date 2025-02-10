import 'package:flutter/material.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/features/list/controllers/list_controller.dart';
import 'package:venturo_core/features/list/view/components/menu_card.dart';
import 'package:venturo_core/features/list/view/components/menu_chip.dart';
import 'package:venturo_core/features/list/view/components/promo_card.dart';
import 'package:venturo_core/features/list/view/components/search_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:venturo_core/shared/widgets/custom_navbar.dart';

class ListScreen extends StatelessWidget {
  ListScreen({Key? key}) : super(key: key);
  final ListController listController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: const CustomNavbar(currentIndex: 0),
        appBar: SearchAppBar(
          onChange: (value) => ListController.to.keyword(value),
        ),
        body: SmartRefresher(
          controller: listController.refreshController,
          enablePullDown: true,
          onRefresh: listController.onRefresh,
          enablePullUp: listController.canLoadMore.isTrue,
          onLoading: () async {
            await listController.fetchData();
            listController.refreshController.loadComplete();
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

                CarouselSlider(
                  options: CarouselOptions(
                    height: 200.h,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                  ),
                  items: listController.promoList.map((promo) {
                    return Builder(
                      builder: (BuildContext context) {
                        return PromoCard(
                          promoName: promo["promoName"]!,
                          discountNominal: promo["discountNominal"]!,
                          thumbnailUrl: promo["thumbnailUrl"]!,
                        );
                      },
                    );
                  }).toList(),
                ),

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

                // Menu List
                // Menu List
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
                                      if (ListController.to.selectedItems
                                          .contains(menu)) {
                                        ListController.to.selectedItems
                                            .remove(menu);
                                      } else {
                                        ListController.to.selectedItems
                                            .add(menu);
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
