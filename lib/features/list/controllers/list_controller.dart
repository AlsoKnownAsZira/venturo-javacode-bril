import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:venturo_core/constants/image_constant.dart';
import 'package:venturo_core/features/list/repositories/list_repository.dart';
import 'package:collection/collection.dart';
class ListController extends GetxController {
  static ListController get to => Get.find<ListController>();

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
    print("getListOfData() has been called");
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
      print("Fetched data: $result");

      if (result.isEmpty) {
        print("No data received.");
        canLoadMore(false);
        refreshController.loadNoData();
      } else {
        items.clear();  // Clear previous items if needed
        items.addAll(result);
        print("Items after adding: $items");
        refreshController.loadComplete();
      }

      return true;
    } catch (exception, stacktrace) {
      print("Exception: $exception");
      await Sentry.captureException(
        exception,
        stackTrace: stacktrace,
      );
      refreshController.loadFailed();
      return false;
    }
  }
  // List<Map<String, dynamic>> get filteredList => items
  //     .where((element) =>
  //         element['nama']
  //             .toString()
  //             .toLowerCase()
  //             .contains(keyword.value.toLowerCase()) &&
  //         (selectedCategory.value == 'semua' ||
  //             element['kategori'] == selectedCategory.value))
  //     .toList();

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
