import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:venturo_core/constants/image_constant.dart';
import 'package:venturo_core/features/list/repositories/list_repository.dart';
import 'package:collection/collection.dart';

class ListController extends GetxController {
  static ListController get to => Get.find<ListController>();
  var selectedLevel = ''.obs;
  var selectedTopping = ''.obs;
  RxList<String> levels = <String>[].obs;
  RxList<String> toppings = <String>[].obs;
  late final ListRepository repository;

  final RxInt page = 0.obs;

  final RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;

  final RxList<Map<String, dynamic>> selectedItems =
      <Map<String, dynamic>>[].obs;

  final RxBool canLoadMore = true.obs;

  final RxString selectedCategory = 'semua'.obs;

  final RxString keyword = ''.obs;

  final List<String> categories = [
    'semua',
    'makanan',
    'minuman',
    'snack',
  ];
  
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void onInit() async {
    super.onInit();

    repository = ListRepository();
    await fetchData();
  }

  void onRefresh() async {
    page(0);
    canLoadMore(true);

    final result = await fetchData();

    if (result) {
      refreshController.refreshCompleted();
    } else {
      refreshController.refreshFailed();
    }
  }

  Future<bool> fetchData() async {
    try {
      final result = await repository.fetchMenuList();

      if (result.isEmpty) {
        canLoadMore(false);
        refreshController.loadNoData();
      } else {
        items.clear();
        items.addAll(result);
        refreshController.loadComplete();
      }

      return true;
    } catch (exception, stacktrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stacktrace,
      );
      refreshController.loadFailed();
      return false;
    }
  }

  Map<String, List<Map<String, dynamic>>> get groupedMenu {
    final filteredItems = items.where((element) {
      final matchesKeyword = element['nama']
          .toString()
          .toLowerCase()
          .contains(keyword.value.toLowerCase());

      final matchesCategory = selectedCategory.value == 'semua' ||
          element['kategori'] == selectedCategory.value;

      return matchesKeyword && matchesCategory;
    }).toList();

    return groupBy(filteredItems, (menu) => menu['kategori'].toString());
  }

  Future<void> fetchMenuDetails(int menuId) async {
    try {
      final menuDetails = await repository.fetchMenuDetail(menuId);
      levels.assignAll(menuDetails['level']);
      toppings.assignAll(menuDetails['topping']);
    } catch (e) {
      print("Error loading menu details: $e");
    }
  }

  void selectLevel(String level) {
    selectedLevel.value = level;
    Get.back();
  }

  void selectTopping(String topping) {
    selectedTopping.value = topping;
    Get.back();
  }

  final RxInt quantity = 0.obs;
  void increment() {
    quantity.value++;
  }

  void decrement() {
    quantity.value--;
  }

  var promoList = [
    {
      "promoName": "Isi survey ini untuk discon GACOR!",
      "discountNominal": "50",
      "thumbnailUrl": ImageConstant.promo1
    },
    {
      "promoName": "Promo untuk anda si paling jago!",
      "discountNominal": "10",
      "thumbnailUrl": ImageConstant.promo2
    },
    {
      "promoName": "Promo jumat berkah!",
      "discountNominal": "15",
      "thumbnailUrl": ImageConstant.promo3
    },
  ];
}