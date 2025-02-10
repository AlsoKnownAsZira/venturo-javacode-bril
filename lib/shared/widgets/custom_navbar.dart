import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:get/get.dart';
import 'package:venturo_core/configs/routes/route.dart';

class CustomNavbar extends StatefulWidget {
  final int currentIndex;
  const CustomNavbar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  _CustomNavbarState createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> {
  void onTabTapped(int index) {
    switch (index) {
      case 0:
        Get.offAndToNamed(MainRoute.list);
        break;
      case 1:
        Get.offAndToNamed(MainRoute.profile);
        break;
      case 2:
        Get.offAndToNamed(MainRoute.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GNav(
      activeColor: Colors.white,
      rippleColor: Colors.grey,
      gap: 8,
      hoverColor: Colors.white,
      tabBackgroundColor: Colors.black,
      selectedIndex: widget.currentIndex,
      onTabChange: (index) {
        onTabTapped(index);
      },
      tabs: const [
        GButton(
          icon: Icons.home,
          text: 'Beranda',
        ),
        GButton(
          icon: Icons.fastfood_rounded,
          text: 'Pesanan',
        ),
        GButton(
          icon: Icons.person,
          text: 'Profil',
        ),
      ],
    );
  }
}