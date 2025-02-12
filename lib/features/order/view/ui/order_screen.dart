import 'package:flutter/material.dart';
import 'package:venturo_core/features/order/constants/order_assets_constant.dart';
import 'package:venturo_core/shared/widgets/custom_navbar.dart';

class OrderScreen extends StatelessWidget {
  OrderScreen({Key? key}) : super(key: key);

  final assetsConstant = OrderAssetsConstant();

  @override
  Widget build(BuildContext context) {
    // Retrieve the orders from the arguments
    final Map<String, List<Map<String, dynamic>>>? orders =
        ModalRoute.of(context)!.settings.arguments as Map<String, List<Map<String, dynamic>>>?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      bottomNavigationBar: const CustomNavbar(currentIndex: 1),
      body: orders == null || orders.isEmpty
          ? const Center(
              child: Text(
                'No orders found.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView(
              children: orders.entries.map((entry) {
                String session = entry.key;
                List<Map<String, dynamic>> sessionOrders = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Session: $session',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...sessionOrders.map((order) {
                      final menu = order['menu'];
                      final quantity = order['quantity'];
                      final level = order['level'];
                      final topping = order['topping'];

                      return ListTile(
                        title: Text(menu['nama'] ?? 'Unknown'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Rp ${menu['harga']}'),
                            if (level != null) Text('Level: $level'),
                            if (topping != null) Text('Topping: $topping'),
                          ],
                        ),
                        trailing: Text('Qty: $quantity'),
                      );
                    }).toList(),
                  ],
                );
              }).toList(),
            ),
    );
  }
}