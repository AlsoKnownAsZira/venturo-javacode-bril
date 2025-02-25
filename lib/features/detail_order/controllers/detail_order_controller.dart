import 'dart:async';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:venturo_core/features/order/repositories/order_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

class DetailOrderController extends GetxController {
  static DetailOrderController get to => Get.find<DetailOrderController>();
  final Logger logger = Logger();

 late final OrderRepository _orderRepository ; 

  // order data
  RxString orderDetailState = 'loading'.obs;
  Rxn<Map<String, dynamic>> order = Rxn();

  Timer? timer;

    @override
  void onInit() {
    super.onInit();

    _orderRepository = OrderRepository();
    final orderId = int.parse(Get.parameters['orderId'] as String);
    final userId = Hive.box('venturo').get('userId');

    getOrderDetail(userId, orderId).then((value) {
      timer = Timer.periodic(
        const Duration(seconds: 10),
        (_) => getOrderDetail(userId, orderId, isPeriodic: true),
      );
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

 Future<void> getOrderDetail(int userId, int orderId,
      {bool isPeriodic = false}) async {
    if (!isPeriodic) {
      orderDetailState('loading');
    }

    try {
      logger
          .d('Fetching order detail for user ID: $userId, order ID: $orderId');
      final result = await _orderRepository.getOrderDetail(userId, orderId);
      logger.d('Order detail fetched successfully: $result');

      // Ensure the menu field is parsed as a list of maps
      if (result != null && result.containsKey('menu')) {
        result['menu'] = List<Map<String, dynamic>>.from(result['menu']);
      }

      orderDetailState('success');
      order(result);
    } catch (exception, stacktrace) {
      logger.e('Failed to fetch order detail: $exception');
      await Sentry.captureException(
        exception,
        stackTrace: stacktrace,
      );

      orderDetailState('error');
    }
  }

  List<Map<String, dynamic>> get foodItems =>
      order.value?['menu']
          .where((element) => element['kategori'] == 'makanan')
          .toList() ??[];

  List<Map<String, dynamic>> get drinkItems =>
      order.value?['menu']
          .where((element) => element['kategori'] == 'minuman')
          .toList() ??[];

  List<Map<String, dynamic>> get snackItems =>
      order.value?['menu']
          .where((element) => element['kategori'] == 'snack')
          .toList() ??[];
}
