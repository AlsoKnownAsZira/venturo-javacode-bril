import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:venturo_core/features/list/controllers/list_controller.dart';

class DetailMenuScreen extends StatelessWidget {
  DetailMenuScreen({Key? key}) : super(key: key);

  final ListController listController = Get.find(); // Use the same controller

  @override
  Widget build(BuildContext context) {
    final menu = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(menu['nama']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
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
            const SizedBox(height: 20),
            Text(
              menu['nama'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ), // Menu name
            const SizedBox(height: 10),
            Text(
              "Kategori: ${menu['kategori']}",
              style: const TextStyle(fontSize: 18),
            ), // Category
            const SizedBox(height: 10),
            Text(
              "Harga: Rp ${menu['harga']}",
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ), // Price
            const SizedBox(height: 10),
            Text(
              menu['deskripsi'],
              style: const TextStyle(fontSize: 16),
            ), // Menu description
          ],
        ),
      ),
    );
  }
}
