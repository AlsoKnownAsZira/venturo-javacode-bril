import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app_settings/app_settings.dart';
import 'package:venturo_core/shared/controllers/global_controllers/initial_controller.dart';

class CheckLocationScreen extends StatelessWidget {
  const CheckLocationScreen({super.key});

  Future<void> _checkLocationService(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      // Navigate to GetLocationScreen if enabled
      GlobalController.to.getLocation();
    } else {
      // Show a dialog prompting the user to enable location
      Get.defaultDialog(
        title: "Lokasi Diperlukan ",
        middleText: "Tolong nyalakan lokasi anda untuk melanjutkan",
        textConfirm: "Buka pengaturan",
        textCancel: "Batal",
        onConfirm: () {
          AppSettings.openAppSettings(type: AppSettingsType.location);
          Get.back(); // Close dialog
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              "Tolong nyalakan lokasi anda untuk melanjutkan! Izinkan juga app ini mengakses lokasi anda .",
              style: Get.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _checkLocationService(context),
              child: const Text("Check Location"),
            ),
          ],
        ),
      ),
    );
  }
}
