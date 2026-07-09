import 'package:get/get.dart';
import 'package:coffee_shop_app/data/models/category_model.dart';
import 'package:coffee_shop_app/data/models/coffee_model.dart';
import 'package:coffee_shop_app/data/repositories/coffee_repository.dart';

/// GetX controller for coffee products and categories
class CoffeeController extends GetxController {
  final CoffeeRepository _repository = CoffeeRepository();

  // Observable state
  final RxList<CoffeeModel> products = <CoffeeModel>[].obs;
  final RxList<CoffeeModel> filteredProducts = <CoffeeModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxString selectedCategory = 'All Coffee'.obs;
  final RxBool isLoading = true.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  /// Load categories and products from repository
  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _repository.getCategories(),
        _repository.getProducts(),
      ]);

      categories.value = results[0] as List<CategoryModel>;
      products.value = results[1] as List<CoffeeModel>;
      filteredProducts.value = products;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Filter products by category
  void filterByCategory(String category) {
    selectedCategory.value = category;
    _applyFilters();
  }

  /// Search products by name
  void searchProducts(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  /// Apply both category and search filters
  void _applyFilters() {
    List<CoffeeModel> result = products;

    // Category filter
    if (selectedCategory.value != 'All Coffee') {
      result = result
          .where((p) => p.category == selectedCategory.value)
          .toList();
    }

    // Search filter
    if (searchQuery.value.isNotEmpty) {
      result = result
          .where((p) =>
              p.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    filteredProducts.value = result;
  }

  /// Refresh data from repository
  Future<void> refreshData() async {
    await _loadData();
  }
}
