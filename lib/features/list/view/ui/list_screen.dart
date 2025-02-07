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
class ListScreen extends StatelessWidget {
  ListScreen({Key? key}) : super(key: key);
  final ListController listController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SearchAppBar(
          onChange: (value) => ListController.to.keyword(value),
        ),
        body: SmartRefresher(
          controller: listController.refreshController,
          enablePullDown: true,
          onRefresh: listController.onRefresh,
          enablePullUp: listController.canLoadMore.isTrue,
          onLoading: () async {
            await listController.getListOfData();
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
                      Icon(Icons.local_offer, size: 30.sp, color: MainColor.primary),
                      SizedBox(width: 10.w),
                      Text(
                        "Available Promo",
                        style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
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
                  child: Obx(() => Row(
                        children: listController.categories.map((category) {
                          return Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: MenuChip(
                              text: category,
                              isSelected: listController.selectedCategory.value == category.toLowerCase(),
                              onTap: () {
                                listController.selectedCategory.value = category.toLowerCase();
                              },
                            ),
                          );
                        }).toList(),
                      )),
                ),

                // Menu Title
                Padding(
                  padding: EdgeInsets.only(top: 20.h, left: 20.h),
                  child: Row(
                    children: [
                      Icon(Icons.menu_book, size: 30.sp, color: MainColor.primary),
                      SizedBox(width: 10.w),
                      Obx(() => Text(
                            listController.selectedCategory.value == 'all'
                                ? "All Menu"
                                : listController.selectedCategory.value == 'food'
                                    ? "Food"
                                    : "Drink",
                            style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),

                // Menu List
             Obx(() => ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listController.filteredList.length,
                      itemBuilder: (context, index) {
                        final menu = listController.filteredList[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    ListController.to.deleteItem(menu);
                                  },
                                  borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(10.r),
                                  ),
                                  backgroundColor: const Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: MenuCard(
                              menu: menu,
                              isSelected: ListController.to.selectedItems.contains(menu),
                              onTap: () {
                                if (ListController.to.selectedItems.contains(menu)) {
                                  ListController.to.selectedItems.remove(menu);
                                } else {
                                  ListController.to.selectedItems.add(menu);
                                }
                              },
                            ),
                          ),
                        );
                      },
                    )),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
