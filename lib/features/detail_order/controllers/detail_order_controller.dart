import 'dart:async';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:venturo_core/features/order/repositories/order_repository.dart';

class DetailOrderController extends GetxController {
  static DetailOrderController get to => Get.find<DetailOrderController>();

  final OrderRepository _orderRepository = OrderRepository(); 

  // order data
  RxString orderDetailState = 'loading'.obs;
  Rxn<Map<String, dynamic>> order = Rxn();

  Timer? timer;

  @override
  void onInit() {
    super.onInit();

    final orderId = int.tryParse(Get.parameters['orderId'] ?? '') ?? 0;
    if (orderId > 0) {
      getOrderDetail(orderId).then((value) {
        timer = Timer.periodic(
          const Duration(seconds: 10),
          (_) => getOrderDetail(orderId, isPeriodic: true),
        );
      });
    } else {
      orderDetailState('error');
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  Future<void> getOrderDetail(int orderId, {bool isPeriodic = false}) async {
    if (!isPeriodic) {
      orderDetailState('loading');
    }

    try {
      final result = _orderRepository.getOrderDetail(orderId);

      if (result != null) {
        orderDetailState('success');
        order(result);
      } else {
        orderDetailState('error');
      }
    } catch (exception, stacktrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stacktrace,
      );
      orderDetailState('error');
    }
  }

  List<Map<String, dynamic>> get foodItems =>
      order.value?['data']['detail']
          .where((element) => element['kategori'] == 'makanan')
          .toList() ?? [];

  List<Map<String, dynamic>> get drinkItems =>
      order.value?['data']['detail']
          .where((element) => element['kategori'] == 'minuman')
          .toList() ?? [];
}
