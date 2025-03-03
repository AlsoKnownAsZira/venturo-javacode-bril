import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:venturo_core/features/order/repositories/order_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

class OrderController extends GetxController {
  static OrderController get to => Get.find<OrderController>();
  late final OrderRepository _orderRepository;
  final Logger logger = Logger();

  @override
  void onInit() {
    super.onInit();

    _orderRepository = OrderRepository();

    getOngoingOrders();
    getOrderHistories();
  }

  RxList<Map<String, dynamic>> onGoingOrders = RxList();
  RxList<Map<String, dynamic>> historyOrders = RxList();

  RxString onGoingOrderState = 'loading'.obs;
  RxString orderHistoryState = 'loading'.obs;

  Rx<String> selectedCategory = 'all'.obs;

  Map<String, String> get dateFilterStatus => {
        'all': 'Semua'.tr,
        'completed': 'Selesai'.tr,
        'cancelled': 'Dibatalkan'.tr,
      };

  Rx<DateTimeRange> selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 1000)),
    end: DateTime.now(),
  ).obs;

  Future<void> getOngoingOrders() async {
    onGoingOrderState('loading');

    try {
      final userId = Hive.box('venturo').get('userId');
      logger.d('Fetching ongoing orders for user ID: $userId');
      final result = await _orderRepository.getOngoingOrder(userId);
      logger.d('Ongoing orders fetched successfully: $result');
      onGoingOrders(result.reversed.toList());

      onGoingOrderState('success');
    } catch (exception, stacktrace) {
      logger.e('Failed to fetch ongoing orders: $exception');
      await Sentry.captureException(
        exception,
        stackTrace: stacktrace,
      );

      onGoingOrderState('error');
    }
  }

   Future<void> getOrderHistories() async {
    orderHistoryState('loading');

    try {
      final userId = Hive.box('venturo').get('userId');
      logger.d('Fetching order histories for user ID: $userId');
      final result = await _orderRepository.getOrderHistory(userId);
      logger.d('Order histories fetched successfully: $result');
      historyOrders(result.reversed.toList());

      orderHistoryState('success');
    } catch (exception, stacktrace) {
      logger.e('Failed to fetch order histories: $exception');
      await Sentry.captureException(
        exception,
        stackTrace: stacktrace,
      );
      orderHistoryState('error');
    }
  }

  void setDateFilter({String? category, DateTimeRange? range}) {
    selectedCategory(category);
    selectedDateRange(range);
  }

 List<Map<String, dynamic>> get filteredHistoryOrder {
  final historyOrderList = historyOrders.toList();

  // Filter by selected category
  if (selectedCategory.value == 'cancelled') {
    historyOrderList.removeWhere((element) => element['status'] != 4);
  } else if (selectedCategory.value == 'completed') {
    historyOrderList.removeWhere((element) => element['status'] != 3);
  }

  // Filter by selected date range
  if (selectedDateRange.value != null) {
    historyOrderList.removeWhere((element) =>
        DateTime.parse(element['tanggal'] as String)
            .isBefore(selectedDateRange.value.start) ||
        DateTime.parse(element['tanggal'] as String)
            .isAfter(selectedDateRange.value.end));
  }

  // Sort by date in descending order
  historyOrderList.sort((a, b) => DateTime.parse(b['tanggal'] as String)
      .compareTo(DateTime.parse(a['tanggal'] as String)));

  return historyOrderList;
}

  String get totalHistoryOrder {
    final total = filteredHistoryOrder.where((e) => e['status'] == 3).fold(
        0,
        (previousValue, element) =>
            previousValue + element['total_bayar'] as int);

    return total.toString();
  }
Future<void> orderAgain(Map<String, dynamic> order) async {
    try {
      final userId = Hive.box('venturo').get('userId');
      logger.d('Re-ordering for user ID: $userId with order ID: ${order['id']}');
      
      final newOrder = {
        "order": {
          "id_user": userId,
          "id_voucher": 1, 
          "potongan": 0, 
          "total_bayar": order['total_bayar']
        },
        "menu": order['menu'].map((item) => {
          "id_menu": item['id_menu'],
          "harga": item['harga'],
          "level": item['level'] ?? 0,
          "topping": item['topping'] ?? [],
          "jumlah": item['jumlah'],
        }).toList()
      };

      await _orderRepository.createOrder(newOrder);
      logger.d('Order created successfully: $newOrder');

      await getOngoingOrders();
    } catch (exception, stacktrace) {
      logger.e('Failed to re-order: $exception');
      await Sentry.captureException(
        exception,
        stackTrace: stacktrace,
      );
    }
  }
  Future<void> cancelOrder(int orderId) async {
  try {
    logger.d('Cancelling order with ID: $orderId');
    await _orderRepository.cancelOrder(orderId);
    await getOngoingOrders();
    Get.snackbar('Success', 'Order cancelled successfully',
        snackPosition: SnackPosition.BOTTOM);
  } catch (exception, stacktrace) {
    logger.e('Failed to cancel order: $exception');
    await Sentry.captureException(
      exception,
      stackTrace: stacktrace,
    );
    Get.snackbar('Error', 'Failed to cancel order',
        snackPosition: SnackPosition.BOTTOM);
  }
}

}