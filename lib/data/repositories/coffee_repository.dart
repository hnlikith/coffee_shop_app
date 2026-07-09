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
          'A rich chocolate-flavored warm beverage made with espresso, steamed milk, and cocoa. The perfect balance of coffee and chocolate indulgence.',
      'price': 4.53,
      'rating': 4.8,
      'image_url':
          'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400',
      'category': 'Latte',
    },
    {
      'id': '2',
      'name': 'Flat White',
      'description':
          'A smooth and velvety coffee with a thin layer of steamed milk over a double shot of espresso. Silky and full-bodied.',
      'price': 3.99,
      'rating': 4.6,
      'image_url':
          'https://images.unsplash.com/photo-1577968897966-3d4325b36b61?w=400',
      'category': 'Latte',
    },
    {
      'id': '3',
      'name': 'Espresso',
      'description':
          'A concentrated shot of bold coffee brewed by forcing hot water through finely ground beans. Pure coffee intensity.',
      'price': 2.99,
      'rating': 4.9,
      'image_url':
          'https://images.unsplash.com/photo-1510707577719-ae7c14805e3a?w=400',
      'category': 'Americano',
    },
    {
      'id': '4',
      'name': 'Cappuccino',
      'description':
          'A classic Italian coffee with equal parts espresso, steamed milk, and rich milk foam. Perfectly balanced and frothy.',
      'price': 4.20,
      'rating': 4.7,
      'image_url':
          'https://images.unsplash.com/photo-1534778101976-62847782c213?w=400',
      'category': 'Macchiato',
    },
    {
      'id': '5',
      'name': 'Macchiato',
      'description':
          'An espresso "stained" with a small dollop of foamed milk for a bold yet balanced flavor. Simple elegance in a cup.',
      'price': 3.50,
      'rating': 4.5,
      'image_url':
          'https://images.unsplash.com/photo-1485808191679-5f86510681a2?w=400',
      'category': 'Macchiato',
    },
    {
      'id': '6',
      'name': 'Americano',
      'description':
          'A smooth, full-bodied coffee made by diluting espresso with hot water. Bold yet approachable and refreshing.',
      'price': 3.00,
      'rating': 4.4,
      'image_url':
          'https://images.unsplash.com/photo-1551030173-122aabc4489c?w=400',
      'category': 'Americano',
    },
    {
      'id': '7',
      'name': 'Latte',
      'description':
          'A creamy coffee made with espresso and a generous pour of steamed milk. Smooth, mild, and absolutely comforting.',
      'price': 4.00,
      'rating': 4.6,
      'image_url':
          'https://images.unsplash.com/photo-1570968915860-54d5c301fa9f?w=400',
      'category': 'Latte',
    },
    {
      'id': '8',
      'name': 'Mocha Latte',
      'description':
          'A decadent blend of espresso, chocolate syrup, and steamed milk topped with whipped cream. The ultimate treat.',
      'price': 5.00,
      'rating': 4.8,
      'image_url':
          'https://images.unsplash.com/photo-1578314675249-a6910f80cc4e?w=400',
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
