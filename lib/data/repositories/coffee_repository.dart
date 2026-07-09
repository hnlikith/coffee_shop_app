import 'package:coffee_shop_app/core/constants/supabase_constants.dart';
import 'package:coffee_shop_app/data/models/category_model.dart';
import 'package:coffee_shop_app/data/models/coffee_model.dart';
import 'package:coffee_shop_app/data/services/supabase_service.dart';

/// Repository layer — business logic for coffee data access
class CoffeeRepository {
  final SupabaseService _service;

  CoffeeRepository({SupabaseService? service})
      : _service = service ?? SupabaseService();

  // ─── Fallback data (used when Supabase is not configured) ───

  static const List<Map<String, dynamic>> _fallbackCategories = [
    {'id': '1', 'name': 'All Coffee'},
    {'id': '2', 'name': 'Macchiato'},
    {'id': '3', 'name': 'Latte'},
    {'id': '4', 'name': 'Americano'},
  ];

  static const List<Map<String, dynamic>> _fallbackProducts = [
    {
      'id': '1',
      'name': 'Caffe Mocha',
      'description':
          'A rich chocolate-flavored warm beverage, made with fresh espresso and hot milk. It is the perfect blend of coffee and chocolate.',
      'price': 4.53,
      'rating': 4.8,
      'image_url': 'assets/images/caffe_mocha.png',
      'category': 'Latte',
    },
    {
      'id': '2',
      'name': 'Flat White',
      'description':
          'Smooth and velvety espresso coffee with microfoam. A classic for those who want strong coffee flavor with a creamy texture.',
      'price': 3.99,
      'rating': 4.6,
      'image_url': 'assets/images/flat_white.png',
      'category': 'Latte',
    },
    {
      'id': '3',
      'name': 'Espresso',
      'description':
          'A concentrated shot of bold coffee. Made by forcing pressurized hot water through finely ground coffee beans.',
      'price': 2.99,
      'rating': 4.9,
      'image_url': 'assets/images/espresso.png',
      'category': 'Americano',
    },
    {
      'id': '4',
      'name': 'Cappuccino',
      'description':
          'Classic Italian coffee with double espresso, hot milk, and steamed milk foam on top.',
      'price': 4.20,
      'rating': 4.7,
      'image_url': 'assets/images/cappuccino.png',
      'category': 'Macchiato',
    },
    {
      'id': '5',
      'name': 'Macchiato',
      'description':
          'Espresso coffee drink with a small amount of milk, usually foamed. Bold flavor with a hint of creaminess.',
      'price': 3.50,
      'rating:': 4.5,
      'image_url': 'assets/images/macchiato.png',
      'category': 'Macchiato',
    },
    {
      'id': '6',
      'name': 'Americano',
      'description':
          'Prepared by brewing espresso with added hot water, giving it a similar strength to, but different flavor from, drip coffee.',
      'price': 3.00,
      'rating': 4.4,
      'image_url': 'assets/images/americano.png',
      'category': 'Americano',
    },
    {
      'id': '7',
      'name': 'Latte',
      'description':
          'A milk coffee that boasts a silky layer of foam as a real highlight to the drink.',
      'price': 4.00,
      'rating': 4.6,
      'image_url': 'assets/images/latte.png',
      'category': 'Latte',
    },
    {
      'id': '8',
      'name': 'Mocha Latte',
      'description':
          'A variant of a caffe latte inspired by the mocha coffee bean. It has a rich chocolate flavor.',
      'price': 5.00,
      'rating': 4.8,
      'image_url': 'assets/images/mocha_latte.png',
      'category': 'Latte',
    },
  ];

  /// Check if Supabase is configured
  bool get _isSupabaseConfigured =>
      SupabaseConstants.supabaseUrl != 'YOUR_SUPABASE_URL' &&
      SupabaseConstants.supabaseAnonKey != 'YOUR_SUPABASE_ANON_KEY';

  // ─── Categories ───

  /// Get all categories
  Future<List<CategoryModel>> getCategories() async {
    try {
      if (_isSupabaseConfigured) {
        final data =
            await _service.fetchAll(SupabaseConstants.categoriesTable);
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      }
    } catch (e) {
      // Fall through to fallback data
    }
    // Use fallback data
    return _fallbackCategories
        .map((json) => CategoryModel.fromJson(json))
        .toList();
  }

  // ─── Products ───

  /// Get all products
  Future<List<CoffeeModel>> getProducts() async {
    try {
      if (_isSupabaseConfigured) {
        final data = await _service.fetchAll(SupabaseConstants.productsTable);
        return data.map((json) => CoffeeModel.fromJson(json)).toList();
      }
    } catch (e) {
      // Fall through to fallback data
    }
    return _fallbackProducts
        .map((json) => CoffeeModel.fromJson(json))
        .toList();
  }

  /// Get products filtered by category
  Future<List<CoffeeModel>> getProductsByCategory(String category) async {
    if (category == 'All Coffee') {
      return getProducts();
    }
    try {
      if (_isSupabaseConfigured) {
        final data = await _service.fetchWhere(
          SupabaseConstants.productsTable,
          'category',
          category,
        );
        return data.map((json) => CoffeeModel.fromJson(json)).toList();
      }
    } catch (e) {
      // Fall through to fallback data
    }
    return _fallbackProducts
        .where((p) => p['category'] == category)
        .map((json) => CoffeeModel.fromJson(json))
        .toList();
  }

  /// Get a single product by ID
  Future<CoffeeModel?> getProductById(String id) async {
    try {
      if (_isSupabaseConfigured) {
        final data =
            await _service.fetchById(SupabaseConstants.productsTable, id);
        return CoffeeModel.fromJson(data);
      }
    } catch (e) {
      // Fall through to fallback data
    }
    final match = _fallbackProducts.where((p) => p['id'] == id);
    if (match.isNotEmpty) {
      return CoffeeModel.fromJson(match.first);
    }
    return null;
  }
}
