import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:venturo_core/configs/routes/route.dart';
import 'package:venturo_core/shared/styles/color_style.dart';

class CustomNavbar extends StatelessWidget {
  final RxInt selectedIndex = 0.obs;

  CustomNavbar({super.key}) {
    // Update selectedIndex based on the current route
    switch (Get.currentRoute) {
      case MainRoute.list:
        selectedIndex.value = 0;
        break;
      case MainRoute.order:
        selectedIndex.value = 1;
        break;

      case MainRoute.profile:
        selectedIndex.value = 2;
        break;
      default:
        selectedIndex.value = 0;
    }
  }

  void onItemTapped(int index) {
    selectedIndex.value = index;
    switch (index) {
      case 0:
        Get.offAndToNamed(MainRoute.list);
        break;
      case 1:
        Get.offAndToNamed(MainRoute.order);
        break;
      case 2:
        Get.offAndToNamed(MainRoute.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          child: BottomNavigationBar(
            backgroundColor: ColorStyle.dark,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            currentIndex: selectedIndex.value,
            onTap: onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.room_service),
                label: 'Pesanan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: 'Profil',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(fontSize: 12.sp),
            unselectedLabelStyle: TextStyle(fontSize: 12.sp),
          ),
        ));
  }
}
