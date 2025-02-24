import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:venturo_core/features/order/repositories/order_repository.dart';

class OrderController extends GetxController {
  static OrderController get to => Get.find<OrderController>();
  late final OrderRepository _orderRepository;

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
        'all': 'All status'.tr,
        'completed': 'Completed'.tr,
        'cancelled': 'Cancelled'.tr,
      };

  Rx<DateTimeRange> selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  ).obs;

  Future<void> getOngoingOrders() async {
    onGoingOrderState('loading');

    try {
      final result = _orderRepository.getOngoingOrder();
      final data = result
          .where((element) => element['data']['order']['status'] != 4)
          .toList();
      onGoingOrders(data.reversed.toList());

      onGoingOrderState('success');
    } catch (exception, stacktrace) {
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
      final result = await _orderRepository.getOrderHistory();
      print("Order history fetched: $result"); // Debugging
      historyOrders.assignAll(result.reversed.toList());
      print("History Orders after update: $historyOrders"); // Debugging

      orderHistoryState('success');
    } catch (exception, stacktrace) {
      print("Error fetching order history: $exception");

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

    if (selectedCategory.value == 'cancelled') {
      historyOrderList
          .removeWhere((element) => element['data']['order']['status'] != 3);
    } else if (selectedCategory.value == 'completed') {
      historyOrderList
          .removeWhere((element) => element['data']['order']['status'] != 4);
    }

    historyOrderList.removeWhere((element) =>
        DateTime.parse(element['data']['order']['tanggal'] as String)
            .isBefore(selectedDateRange.value.start) ||
        DateTime.parse(element['data']['order']['tanggal'] as String)
            .isAfter(selectedDateRange.value.end));

    historyOrderList.sort((a, b) =>
        DateTime.parse(b['data']['order']['tanggal'] as String).compareTo(
            DateTime.parse(a['data']['order']['tanggal'] as String)));

    return historyOrderList;
  }

  String get totalHistoryOrder {
    final total = filteredHistoryOrder.where((e) => e['status'] == 3).fold(
        0,
        (previousValue, element) =>
            previousValue + element['total_bayar'] as int);

    return total.toString();
  }
}
